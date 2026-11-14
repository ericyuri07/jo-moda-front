/// Combinação tamanho + cor com estoque (tabela `product_variants`).
class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    required this.stock,
  });

  final String id;
  final String productId;
  final String size;
  final String color;
  final int stock;

  bool get inStock => stock > 0;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'].toString(),
      productId: json['product_id'].toString(),
      size: json['size'].toString(),
      color: json['color'].toString(),
      stock: (json['stock'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'product_id': productId,
    'size': size,
    'color': color,
    'stock': stock,
  };
}
