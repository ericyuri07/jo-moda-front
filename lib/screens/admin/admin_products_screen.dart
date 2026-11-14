import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';
import '../../services/api_exception.dart';
import '../../services/service_locator.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/network_image_box.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';
import 'widgets/admin_action_button.dart';
import 'widgets/admin_stat_tile.dart';

/// Listagem de produtos para o administrador (CRUD: ler e excluir; criar e
/// editar abrem o formulário). Mostra também os produtos inativos.
class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List<Product> _products = const <Product>[];
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
      final List<Product> products = await productService.getAdminProducts();
      if (mounted) setState(() => _products = products);
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

  Future<void> _openForm([Product? product]) async {
    final bool? saved = product == null
        ? await context.pushNamed<bool>(AppRoutes.adminProductNew)
        : await context.pushNamed<bool>(
            AppRoutes.adminProductEdit,
            pathParameters: <String, String>{'id': product.id},
          );

    if (saved == true) {
      _showMessage(AppStrings.productSaved);
      await _load();
    }
  }

  Future<void> _confirmDelete(Product product) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteProductTitle),
        content: Text(AppStrings.deleteProductMessage(product.name)),
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
      await productService.deleteProduct(product.id);
      _showMessage(AppStrings.productDeleted);
      await _load();
    } on ApiException catch (e) {
      _showMessage(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.home),
        ),
        title: const Text(AppStrings.adminProductsTitle),
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.manageCategoriesTooltip,
            icon: const Icon(Icons.category_outlined),
            onPressed: () => context.pushNamed(AppRoutes.adminCategories),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newProduct),
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

    if (_products.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        message: AppStrings.noProductsRegistered,
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        // Espaço no fim para o botão "Novo produto" não cobrir o último item.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xl,
          AppSpacing.screenPadding,
          AppSpacing.xxl * 3,
        ),
        children: <Widget>[
          _buildStats(),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            AppStrings.catalogTitle,
            trailing: AppStrings.productCount(_products.length),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final Product product in _products) ...<Widget>[
            _buildTile(product),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: <Widget>[
        Expanded(
          child: AdminStatTile(
            value: _products.length,
            label: AppStrings.statsProducts,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AdminStatTile(
            value: _products.where((p) => p.active).length,
            label: AppStrings.statsActive,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AdminStatTile(
            value: _products.where((p) => p.featured).length,
            label: AppStrings.statsFeatured,
          ),
        ),
      ],
    );
  }

  Widget _buildTile(Product product) {
    final int stock = product.variants.fold(0, (sum, v) => sum + v.stock);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: AppSizes.adminThumb,
              height: AppSizes.adminThumb,
              child: NetworkImageBox(url: product.imageUrl),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyStrong,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  Formatters.currency(product.currentPrice),
                  style: product.hasPromotion
                      ? AppTextStyles.priceHighlight
                      : AppTextStyles.price,
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    if (stock == 0)
                      const StatusBadge(
                        label: AppStrings.badgeOutOfStock,
                        color: AppColors.danger,
                      )
                    else
                      Text(
                        AppStrings.adminStock(stock),
                        style: AppTextStyles.caption,
                      ),
                    if (product.featured)
                      const StatusBadge(
                        label: AppStrings.badgeFeatured,
                        color: AppColors.goldDark,
                      ),
                    if (!product.active)
                      const StatusBadge(
                        label: AppStrings.badgeInactive,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ],
            ),
          ),
          AdminActionButton.edit(onPressed: () => _openForm(product)),
          const SizedBox(width: AppSpacing.sm),
          AdminActionButton.delete(onPressed: () => _confirmDelete(product)),
        ],
      ),
    );
  }
}
