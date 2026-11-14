import 'json_parsers.dart';

/// Linha do carrinho: uma variação (tamanho + cor) de um produto.
class CartItem {
  const CartItem({
    required this.variantId,
    required this.productId,
    required this.name,
    required this.price,
    required this.size,
    required this.color,
    required this.quantity,
    required this.stock,
    this.promotionalPrice,
    this.imageUrl,
  });

  final String variantId;
  final String productId;
  final String name;
  final String? imageUrl;
  final double price;
  final double? promotionalPrice;
  final String size;
  final String color;
  final int quantity;

  /// Estoque da variação quando foi adicionada: limite da quantidade.
  final int stock;

  bool get hasPromotion =>
      promotionalPrice != null && promotionalPrice! < price;

  double get unitPrice => hasPromotion ? promotionalPrice! : price;

  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      variantId: variantId,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      promotionalPrice: promotionalPrice,
      size: size,
      color: color,
      quantity: quantity ?? this.quantity,
      stock: stock,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      variantId: json['variant_id'].toString(),
      productId: json['product_id'].toString(),
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      price: parseDouble(json['price']),
      promotionalPrice: parseNullableDouble(json['promotional_price']),
      size: json['size'] as String,
      color: json['color'] as String,
      quantity: (json['quantity'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'variant_id': variantId,
    'product_id': productId,
    'name': name,
    'image_url': imageUrl,
    'price': price,
    'promotional_price': promotionalPrice,
    'size': size,
    'color': color,
    'quantity': quantity,
    'stock': stock,
  };
}
