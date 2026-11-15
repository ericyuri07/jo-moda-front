import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../models/category.dart';
import '../../../models/category_input.dart';
import '../../../services/api_exception.dart';
import '../../../services/service_locator.dart';
import 'photo_picker_field.dart';

/// Janela para criar ou editar uma categoria: foto (enviada na hora) e nome.
/// O slug é gerado pelo back-end. Fecha devolvendo um [CategoryInput], ou
/// `null` se cancelar.
class CategoryFormDialog extends StatefulWidget {
  const CategoryFormDialog({this.category, super.key});

  /// Categoria a editar. Sem ela, a janela é de "Nova categoria".
  final Category? category;

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.category?.name ?? '',
  );
  late String? _imageUrl = widget.category?.imageUrl;

  bool _isUploading = false;
  String? _uploadError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    setState(() {
      _isUploading = true;
      _uploadError = null;
    });

    try {
      final String? url = await photoUploader.pickAndUpload();
      if (!mounted) return;
      if (url != null) setState(() => _imageUrl = url);
    } on ApiException catch (e) {
      if (mounted) setState(() => _uploadError = e.message);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _submit() {
    if (_isUploading || !_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      CategoryInput(name: _nameController.text.trim(), imageUrl: _imageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.category != null;
    final String? error = _uploadError;

    return AlertDialog(
      title: Text(isEditing ? AppStrings.editCategory : AppStrings.newCategory),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.authMaxWidth),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  AppStrings.categoryPhotoLabel,
                  style: AppTextStyles.fieldLabel,
                ),
                const SizedBox(height: AppSpacing.sm),
                PhotoPickerField(
                  url: _imageUrl,
                  isUploading: _isUploading,
                  onPick: _pickPhoto,
                  onRemove: () => setState(() => _imageUrl = null),
                ),
                if (error != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    error,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  AppStrings.categoryNameLabel,
                  style: AppTextStyles.fieldLabel,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    hintText: AppStrings.categoryNameHint,
                  ),
                  validator: (value) => Validators.required(
                    value,
                    field: AppStrings.fieldCategoryName,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: _isUploading ? null : _submit,
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }
}
