import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/category.dart';
import '../../models/category_input.dart';
import '../../models/product.dart';
import '../../services/api_exception.dart';
import '../../services/service_locator.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/network_image_box.dart';
import '../../widgets/section_header.dart';
import 'widgets/admin_action_button.dart';
import 'widgets/category_form_dialog.dart';

/// Categorias da loja (só admin): lista com a quantidade de produtos de cada
/// uma, criar, renomear e excluir. As mudanças aparecem na Home e no
/// formulário de produto.
class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  List<Category> _categories = const <Category>[];
  Map<String, int> _productCount = const <String, int>{};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // As duas chamadas começam juntas; o Future.wait repassa o primeiro erro.
      final Future<List<Category>> categoriesFuture = categoryService
          .getCategories();
      final Future<List<Product>> productsFuture = productService
          .getAdminProducts();
      await Future.wait<Object>(<Future<Object>>[
        categoriesFuture,
        productsFuture,
      ]);

      final List<Category> categories = await categoriesFuture;
      final Map<String, int> count = <String, int>{};
      for (final Product product in await productsFuture) {
        count[product.categoryId] = (count[product.categoryId] ?? 0) + 1;
      }

      if (!mounted) return;
      setState(() {
        _categories = categories;
        _productCount = count;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } on Object {
      if (mounted) setState(() => _errorMessage = AppStrings.loadError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Cria (sem [category]) ou edita a categoria (nome e foto).
  Future<void> _openForm([Category? category]) async {
    final CategoryInput? input = await showDialog<CategoryInput>(
      context: context,
      builder: (dialogContext) => CategoryFormDialog(category: category),
    );
    if (input == null) return;
    if (category != null &&
        input.name == category.name &&
        input.imageUrl == category.imageUrl) {
      return; // nada mudou
    }

    try {
      if (category == null) {
        await categoryService.createCategory(input);
      } else {
        await categoryService.updateCategory(category.id, input);
      }
      _showMessage(AppStrings.categorySaved);
      await _load();
    } on ApiException catch (e) {
      _showMessage(e.message);
    }
  }

  Future<void> _confirmDelete(Category category) async {
    // Com produtos, o back-end recusa: avisa antes, sem abrir a confirmação.
    if ((_productCount[category.id] ?? 0) > 0) {
      _showMessage(AppStrings.categoryInUse);
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteCategoryTitle),
        content: Text(AppStrings.deleteCategoryMessage(category.name)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await categoryService.deleteCategory(category.id);
      _showMessage(AppStrings.categoryDeleted);
      await _load();
    } on ApiException catch (e) {
      _showMessage(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Aberta pelo menu lateral não há tela anterior: volta para a loja.
        leading: context.canPop()
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.goNamed(AppRoutes.home),
              ),
        title: const Text(AppStrings.adminCategoriesTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newCategory),
      ),
      body: _buildBody(),
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

    if (_categories.isEmpty) {
      return EmptyState(
        icon: Icons.category_outlined,
        message: AppStrings.noCategories,
        actionLabel: AppStrings.newCategory,
        onAction: _openForm,
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        // Espaço no fim para o botão "Nova categoria" não cobrir o último item.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xl,
          AppSpacing.screenPadding,
          AppSpacing.xxl * 3,
        ),
        children: <Widget>[
          SectionHeader(
            AppStrings.allCategoriesTitle,
            trailing: '${_categories.length}',
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final Category category in _categories) ...<Widget>[
            _buildTile(category),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }

  Widget _buildTile(Category category) {
    final int count = _productCount[category.id] ?? 0;
    final String initial = category.name.isEmpty
        ? ''
        : category.name.substring(0, 1).toUpperCase();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: AppSizes.adminThumb,
              height: AppSizes.adminThumb,
              alignment: Alignment.center,
              color: AppColors.authBackground,
              // Com foto, mostra a foto; sem foto, a inicial dourada.
              child: (category.imageUrl ?? '').isEmpty
                  ? Text(
                      initial,
                      style: AppTextStyles.sectionHeading.copyWith(
                        color: AppColors.gold,
                      ),
                    )
                  : NetworkImageBox(url: category.imageUrl),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyStrong,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.categoryProducts(count),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          AdminActionButton.edit(onPressed: () => _openForm(category)),
          const SizedBox(width: AppSpacing.sm),
          AdminActionButton.delete(onPressed: () => _confirmDelete(category)),
        ],
      ),
    );
  }
}
