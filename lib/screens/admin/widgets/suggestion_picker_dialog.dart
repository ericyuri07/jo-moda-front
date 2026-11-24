import 'package:flutter/material.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/product.dart';
import '../../../widgets/network_image_box.dart';

/// Janela para escolher os produtos do "Veja também", com busca por nome.
/// Fecha devolvendo a lista na ordem em que foram marcados, ou `null` se
/// cancelar.
class SuggestionPickerDialog extends StatefulWidget {
  const SuggestionPickerDialog({
    required this.products,
    required this.selected,
    super.key,
  });

  /// Produtos que podem ser sugeridos (sem o que está sendo editado).
  final List<Product> products;
  final List<Product> selected;

  @override
  State<SuggestionPickerDialog> createState() => _SuggestionPickerDialogState();
}

class _SuggestionPickerDialogState extends State<SuggestionPickerDialog> {
  late final List<Product> _selected = List<Product>.of(widget.selected);
  String _query = '';

  bool get _isFull => _selected.length >= AppConfig.maxSuggestions;

  bool _isSelected(Product product) => _selected.any((p) => p.id == product.id);

  List<Product> get _visible {
    final String query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.products;
    return widget.products
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();
  }

  void _toggle(Product product, bool isChecked) {
    setState(() {
      if (isChecked) {
        _selected.add(product);
      } else {
        _selected.removeWhere((p) => p.id == product.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> visible = _visible;

    return AlertDialog(
      title: const Text(AppStrings.suggestionsTitle),
      content: SizedBox(
        width: AppSizes.authMaxWidth,
        height: AppSizes.suggestionPickerHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: AppStrings.suggestionsSearchHint,
                prefixIcon: Icon(Icons.search_rounded, size: AppSizes.iconSm),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.suggestionsCount(
                _selected.length,
                AppConfig.maxSuggestions,
              ),
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: visible.isEmpty
                  ? const Center(
                      child: Text(
                        AppStrings.noProducts,
                        style: AppTextStyles.caption,
                      ),
                    )
                  : Material(
                      type: MaterialType.transparency,
                      child: ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (context, i) => _buildItem(visible[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: const Text(AppStrings.confirm),
        ),
      ],
    );
  }

  Widget _buildItem(Product product) {
    final bool isSelected = _isSelected(product);
    final String price = Formatters.currency(product.currentPrice);

    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: isSelected,
      onChanged: _isFull && !isSelected
          ? null
          : (value) => _toggle(product, value ?? false),
      secondary: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: SizedBox(
          width: AppSizes.actionButton,
          height: AppSizes.actionButton,
          child: NetworkImageBox(url: product.imageUrl),
        ),
      ),
      title: Text(
        product.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body,
      ),
      subtitle: Text(
        product.active ? price : '$price · ${AppStrings.badgeInactive}',
        style: AppTextStyles.caption,
      ),
    );
  }
}
