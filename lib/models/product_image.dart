/// Foto extra do produto (tabela `product_images`).
class ProductImage {
  const ProductImage({
    required this.id,
    required this.productId,
    required this.imageUrl,
  });

  final String id;
  final String productId;
  final String imageUrl;

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'].toString(),
      productId: json['product_id'].toString(),
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'product_id': productId,
    'image_url': imageUrl,
  };
}
