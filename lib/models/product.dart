import 'json_parsers.dart';
import 'product_image.dart';
import 'product_variant.dart';

/// Produto (tabela `products`) com variações e imagens quando a API as envia.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.categoryId,
    this.description,
    this.promotionalPrice,
    this.imageUrl,
    this.featured = false,
    this.active = true,
    this.variants = const <ProductVariant>[],
    this.images = const <ProductImage>[],
    this.suggestions = const <Product>[],
  });

  final String id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? promotionalPrice;
  final String categoryId;
  final String? imageUrl;
  final bool featured;
  final bool active;
  final List<ProductVariant> variants;
  final List<ProductImage> images;

  /// Produtos escolhidos no admin para o "Veja também", em ordem.
  final List<Product> suggestions;

  /// Promoção só vale se for menor que o preço (mesma regra do back-end).
  bool get hasPromotion =>
      promotionalPrice != null && promotionalPrice! < price;

  /// Preço que o cliente de fato paga.
  double get currentPrice => hasPromotion ? promotionalPrice! : price;

  /// Tamanhos distintos, na ordem em que aparecem.
  List<String> get sizes =>
      variants.map((v) => v.size).toSet().toList(growable: false);

  /// Cores distintas, na ordem em que aparecem.
  List<String> get colors =>
      variants.map((v) => v.color).toSet().toList(growable: false);

  /// Foto principal seguida das fotos extras, sem repetir.
  List<String> get galleryUrls {
    final List<String> urls = <String>[];
    final String? main = imageUrl;
    if (main != null && main.isNotEmpty) urls.add(main);

    for (final ProductImage image in images) {
      if (image.imageUrl.isNotEmpty && !urls.contains(image.imageUrl)) {
        urls.add(image.imageUrl);
      }
    }
    return urls;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: parseDouble(json['price']),
      promotionalPrice: parseNullableDouble(json['promotional_price']),
      categoryId: json['category_id'].toString(),
      imageUrl: json['image_url'] as String?,
      featured: (json['featured'] as bool?) ?? false,
      active: (json['active'] as bool?) ?? true,
      variants: ((json['variants'] as List<dynamic>?) ?? <dynamic>[])
          .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: ((json['images'] as List<dynamic>?) ?? <dynamic>[])
          .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      suggestions: ((json['suggestions'] as List<dynamic>?) ?? <dynamic>[])
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'price': price,
    'promotional_price': promotionalPrice,
    'category_id': categoryId,
    'image_url': imageUrl,
    'featured': featured,
    'active': active,
    'variants': variants.map((v) => v.toJson()).toList(),
    'images': images.map((i) => i.toJson()).toList(),
    'suggestions': suggestions.map((p) => p.toJson()).toList(),
  };
}
