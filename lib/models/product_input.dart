import 'variant_input.dart';

/// Dados enviados à API para criar ou editar um produto.
///
/// [toJson] leva as colunas de `products` e os sugeridos. Estoque e fotos extras têm
/// rotas próprias no back-end (`/product-variants` e `/product-images`), então
/// vão nas listas abaixo e o `ProductService` grava cada uma depois do produto.
class ProductInput {
  const ProductInput({
    required this.name,
    required this.price,
    required this.categoryId,
    this.description,
    this.promotionalPrice,
    this.imageUrl,
    this.featured = false,
    this.active = true,
    this.suggestionIds = const <String>[],
    this.variants = const <VariantInput>[],
    this.removedVariantIds = const <String>[],
    this.newImageUrls = const <String>[],
    this.removedImageIds = const <String>[],
  });

  final String name;
  final String? description;
  final double price;
  final double? promotionalPrice;
  final String categoryId;
  final String? imageUrl;
  final bool featured;
  final bool active;

  /// Produtos do "Veja também", na ordem; vazia = automático.
  final List<String> suggestionIds;

  /// Variações novas e existentes com estoque alterado.
  final List<VariantInput> variants;
  final List<String> removedVariantIds;

  final List<String> newImageUrls;
  final List<String> removedImageIds;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'description': description,
    'price': price,
    'promotional_price': promotionalPrice,
    'category_id': categoryId,
    'image_url': imageUrl,
    'featured': featured,
    'active': active,
    'suggestion_ids': suggestionIds,
  };
}
