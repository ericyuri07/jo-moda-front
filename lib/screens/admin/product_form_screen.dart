import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../models/product_image.dart';
import '../../models/product_input.dart';
import '../../models/product_variant.dart';
import '../../models/variant_input.dart';
import '../../services/api_exception.dart';
import '../../services/service_locator.dart';
import '../../widgets/error_state.dart';
import '../../widgets/labeled_field.dart';
import 'photo_uploader.dart';
import 'widgets/extra_image_tile.dart';
import 'widgets/form_section_card.dart';
import 'widgets/photo_picker_field.dart';
import 'widgets/variant_stock_row.dart';

/// Formulário de produto: cria (sem `productId`) ou edita (com `productId`).
///
/// Além dos dados do produto, edita o estoque de cada variação e as fotos.
/// As fotos são escolhidas na galeria / no computador e enviadas na hora
/// (`POST /api/uploads`); o resto é gravado ao tocar em "Salvar". Ao terminar
/// volta para a listagem com o resultado `true`.
class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({this.productId, super.key});

  final String? productId;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

/// Variação na tela: existente (com [id]) ou nova, com o estoque editável.
class _VariantDraft {
  _VariantDraft({required this.size, required this.color, required int stock})
    : id = null,
      _originalStock = stock,
      stockController = TextEditingController(text: '$stock');

  _VariantDraft.fromVariant(ProductVariant variant)
    : id = variant.id,
      size = variant.size,
      color = variant.color,
      _originalStock = variant.stock,
      stockController = TextEditingController(text: '${variant.stock}');

  final String? id;
  final String size;
  final String color;
  final int _originalStock;
  final TextEditingController stockController;

  int get stock => int.tryParse(stockController.text.trim()) ?? 0;

  /// Só vai para a API se for nova ou se o estoque mudou.
  bool get needsSaving => id == null || stock != _originalStock;

  bool sameCombination(String otherSize, String otherColor) =>
      size.toLowerCase() == otherSize.toLowerCase() &&
      color.toLowerCase() == otherColor.toLowerCase();

  VariantInput toInput() =>
      VariantInput(id: id, size: size, color: color, stock: stock);
}

/// Foto extra na tela: existente (com [id]) ou nova (só a URL).
class _ImageDraft {
  const _ImageDraft({required this.url, this.id});

  final String? id;
  final String url;
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _sizesController = TextEditingController();
  final TextEditingController _colorsController = TextEditingController();
  final TextEditingController _initialStockController = TextEditingController(
    text: '0',
  );
  final PhotoUploader _uploader = PhotoUploader();

  List<Category> _categories = const <Category>[];
  String? _categoryId;
  String? _mainImageUrl;
  bool _featured = false;
  bool _active = true;

  final List<_VariantDraft> _variants = <_VariantDraft>[];
  final List<String> _removedVariantIds = <String>[];
  final List<_ImageDraft> _images = <_ImageDraft>[];
  final List<String> _removedImageIds = <String>[];

  bool _isLoading = true;
  bool _isSaving = false;

  /// Qual foto está sendo enviada: a principal ou uma extra.
  bool _isUploadingMain = false;
  bool _isUploadingExtra = false;
  String? _errorMessage;

  bool get _isUploading => _isUploadingMain || _isUploadingExtra;

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _promoController.dispose();
    _sizesController.dispose();
    _colorsController.dispose();
    _initialStockController.dispose();
    for (final _VariantDraft draft in _variants) {
      draft.stockController.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<Category> categories = await categoryService.getCategories();

      final String? id = widget.productId;
      final Product? product = id == null
          ? null
          : await productService.getAdminProduct(id);

      if (!mounted) return;
      setState(() {
        _categories = categories;
        if (product != null) _fill(product);

        // Categoria que não está mais na lista (ex.: removida) faria o
        // Dropdown lançar erro: nesse caso o admin escolhe de novo.
        if (!categories.any((c) => c.id == _categoryId)) _categoryId = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } on Object {
      if (mounted) setState(() => _errorMessage = AppStrings.loadError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _fill(Product product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description ?? '';
    _priceController.text = Formatters.moneyForField(product.price);
    _promoController.text = product.promotionalPrice == null
        ? ''
        : Formatters.moneyForField(product.promotionalPrice!);
    _mainImageUrl = product.imageUrl;
    _categoryId = product.categoryId;
    _featured = product.featured;
    _active = product.active;

    for (final _VariantDraft draft in _variants) {
      draft.stockController.dispose();
    }
    _variants
      ..clear()
      ..addAll(product.variants.map(_VariantDraft.fromVariant));
    _removedVariantIds.clear();

    _images
      ..clear()
      ..addAll(
        product.images.map(
          (ProductImage image) =>
              _ImageDraft(id: image.id, url: image.imageUrl),
        ),
      );
    _removedImageIds.clear();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? _optional(TextEditingController controller) {
    final String text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  // ---- categorias ----

  /// Abre o cadastro de categorias e, ao voltar, recarrega a lista do campo
  /// sem perder o que já foi digitado no formulário.
  Future<void> _openCategories() async {
    await context.pushNamed(AppRoutes.adminCategories);

    try {
      final List<Category> categories = await categoryService.getCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        if (!categories.any((c) => c.id == _categoryId)) _categoryId = null;
      });
    } on ApiException catch (e) {
      _showMessage(e.message);
    }
  }

  // ---- estoque ----

  /// Cria as combinações tamanho x cor que ainda não estão na lista.
  void _generateVariants() {
    final List<String> sizes = Formatters.splitList(_sizesController.text);
    final List<String> colors = Formatters.splitList(_colorsController.text);
    if (sizes.isEmpty || colors.isEmpty) {
      _showMessage(AppStrings.variantsGenerateMissing);
      return;
    }

    final int stock = int.tryParse(_initialStockController.text.trim()) ?? 0;
    final List<_VariantDraft> created = <_VariantDraft>[
      for (final String color in colors)
        for (final String size in sizes)
          if (!_variants.any((v) => v.sameCombination(size, color)))
            _VariantDraft(size: size, color: color, stock: stock),
    ];

    if (created.isEmpty) {
      _showMessage(AppStrings.variantsNothingNew);
      return;
    }

    setState(() {
      _variants.addAll(created);
      _sizesController.clear();
      _colorsController.clear();
    });
  }

  void _removeVariant(_VariantDraft draft) {
    setState(() {
      _variants.remove(draft);
      final String? id = draft.id;
      if (id != null) _removedVariantIds.add(id);
    });
    // O campo ainda está na tela neste frame: descarta o controller depois.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => draft.stockController.dispose(),
    );
  }

  // ---- fotos ----

  /// Abre a galeria (ou o seletor de arquivos no navegador), reduz a foto e
  /// envia para a API. Devolve a URL, ou `null` se cancelou ou deu erro.
  Future<String?> _pickAndUpload() async {
    try {
      return await _uploader.pickAndUpload();
    } on ApiException catch (e) {
      _showMessage(e.message);
      return null;
    }
  }

  Future<void> _pickMainImage() async {
    setState(() => _isUploadingMain = true);
    final String? url = await _pickAndUpload();
    if (!mounted) return;
    setState(() {
      if (url != null) _mainImageUrl = url;
      _isUploadingMain = false;
    });
  }

  Future<void> _addImage() async {
    setState(() => _isUploadingExtra = true);
    final String? url = await _pickAndUpload();
    if (!mounted) return;
    setState(() {
      if (url != null) _images.add(_ImageDraft(url: url));
      _isUploadingExtra = false;
    });
  }

  void _removeImage(_ImageDraft image) {
    setState(() {
      _images.remove(image);
      final String? id = image.id;
      if (id != null) _removedImageIds.add(id);
    });
  }

  // ---- salvar ----

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final ProductInput input = ProductInput(
        name: _nameController.text.trim(),
        description: _optional(_descriptionController),
        price: Formatters.parseMoney(_priceController.text)!,
        promotionalPrice: Formatters.parseMoney(_promoController.text),
        categoryId: _categoryId!,
        imageUrl: _mainImageUrl,
        featured: _featured,
        active: _active,
        variants: <VariantInput>[
          for (final _VariantDraft draft in _variants)
            if (draft.needsSaving) draft.toInput(),
        ],
        removedVariantIds: List<String>.of(_removedVariantIds),
        newImageUrls: <String>[
          for (final _ImageDraft image in _images)
            if (image.id == null) image.url,
        ],
        removedImageIds: List<String>.of(_removedImageIds),
      );

      await productService.saveProduct(input, id: widget.productId);

      if (mounted) context.pop(true);
    } on ApiException catch (e) {
      _showMessage(e.message);
    } on Object {
      _showMessage(AppStrings.saveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ---- interface ----

  @override
  Widget build(BuildContext context) {
    final bool showSave = !_isLoading && _errorMessage == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? AppStrings.editProduct : AppStrings.newProduct,
        ),
      ),
      body: _buildBody(),
      // Salvar fica sempre à mão, fixo embaixo.
      bottomNavigationBar: showSave ? _buildSaveBar() : null,
    );
  }

  Widget _buildSaveBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.card,
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.gold,
              ),
              // Espera a foto terminar de subir antes de salvar.
              onPressed: _isSaving || _isUploading ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: AppSizes.spinner,
                      height: AppSizes.spinner,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.borderWidthSelected,
                      ),
                    )
                  : const Icon(Icons.check),
              label: const Text(AppStrings.save),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final String? error = _errorMessage;
    if (error != null) {
      return ErrorState(message: error, onRetry: _load);
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: <Widget>[
              _buildInfoSection(),
              const SizedBox(height: AppSpacing.lg),
              FormSectionCard(
                title: AppStrings.productImageLabel,
                icon: Icons.photo_camera_outlined,
                children: <Widget>[
                  PhotoPickerField(
                    url: _mainImageUrl,
                    isUploading: _isUploadingMain,
                    onPick: _pickMainImage,
                    onRemove: () => setState(() => _mainImageUrl = null),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildVisibilitySection(),
              const SizedBox(height: AppSpacing.lg),
              _buildVariantSection(),
              const SizedBox(height: AppSpacing.lg),
              _buildImageSection(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return FormSectionCard(
      title: AppStrings.formInfoTitle,
      icon: Icons.sell_outlined,
      children: <Widget>[
        LabeledField(
          label: AppStrings.productNameLabel,
          controller: _nameController,
          textInputAction: TextInputAction.next,
          validator: (value) =>
              Validators.required(value, field: AppStrings.fieldProductName),
        ),
        const SizedBox(height: AppSpacing.lg),
        LabeledField(
          label: AppStrings.productDescriptionLabel,
          controller: _descriptionController,
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: LabeledField(
                label: AppStrings.productPriceLabel,
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: Validators.price,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: LabeledField(
                label: AppStrings.productPromoLabel,
                controller: _promoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    Validators.promotionalPrice(value, _priceController.text),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                AppStrings.productCategoryLabel,
                style: AppTextStyles.fieldLabel,
              ),
            ),
            TextButton.icon(
              onPressed: _openCategories,
              icon: const Icon(Icons.category_outlined, size: AppSizes.iconXs),
              label: const Text(AppStrings.manageCategoriesLink),
            ),
          ],
        ),
        DropdownButtonFormField<String>(
          // A chave muda com a lista: ao voltar das categorias, o campo é
          // recriado com as opções novas.
          key: ValueKey<int>(_categories.length),
          initialValue: _categoryId,
          borderRadius: BorderRadius.circular(AppRadius.md),
          items: <DropdownMenuItem<String>>[
            for (final Category category in _categories)
              DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.name),
              ),
          ],
          onChanged: (value) => setState(() => _categoryId = value),
          validator: (value) =>
              Validators.required(value, field: AppStrings.fieldCategory),
        ),
      ],
    );
  }

  Widget _buildVisibilitySection() {
    return FormSectionCard(
      title: AppStrings.formVisibilityTitle,
      icon: Icons.visibility_outlined,
      children: <Widget>[
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            AppStrings.productFeaturedLabel,
            style: AppTextStyles.body,
          ),
          value: _featured,
          onChanged: (value) => setState(() => _featured = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            AppStrings.productActiveLabel,
            style: AppTextStyles.body,
          ),
          value: _active,
          onChanged: (value) => setState(() => _active = value),
        ),
      ],
    );
  }

  Widget _buildVariantSection() {
    return FormSectionCard(
      title: AppStrings.variantsTitle,
      icon: Icons.inventory_2_outlined,
      children: <Widget>[
        if (_variants.isEmpty)
          const Text(AppStrings.variantsEmpty, style: AppTextStyles.caption)
        else
          for (final _VariantDraft draft in _variants)
            VariantStockRow(
              key: ObjectKey(draft),
              size: draft.size,
              color: draft.color,
              stockController: draft.stockController,
              onRemove: () => _removeVariant(draft),
            ),
        const SizedBox(height: AppSpacing.md),
        const Divider(),
        const SizedBox(height: AppSpacing.md),
        const Text(
          AppStrings.variantsGenerateTitle,
          style: AppTextStyles.fieldLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledField(
          label: AppStrings.variantsSizesLabel,
          hintText: AppStrings.variantsSizesHint,
          controller: _sizesController,
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledField(
          label: AppStrings.variantsColorsLabel,
          hintText: AppStrings.variantsColorsHint,
          controller: _colorsController,
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledField(
          label: AppStrings.variantsStockLabel,
          controller: _initialStockController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: _generateVariants,
          icon: const Icon(Icons.add),
          label: const Text(AppStrings.variantsGenerateButton),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return FormSectionCard(
      title: AppStrings.extraImagesTitle,
      icon: Icons.collections_outlined,
      children: <Widget>[
        if (_images.isEmpty)
          const Text(AppStrings.extraImagesEmpty, style: AppTextStyles.caption)
        else
          for (final _ImageDraft image in _images)
            ExtraImageTile(
              key: ObjectKey(image),
              url: image.url,
              onRemove: () => _removeImage(image),
            ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: _isUploading ? null : _addImage,
          icon: _isUploadingExtra
              ? const SizedBox(
                  width: AppSizes.spinner,
                  height: AppSizes.spinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.borderWidthSelected,
                  ),
                )
              : const Icon(Icons.add_photo_alternate_outlined),
          label: Text(
            _isUploadingExtra
                ? AppStrings.photoUploading
                : AppStrings.extraImageAdd,
          ),
        ),
      ],
    );
  }
}
