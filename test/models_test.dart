import 'package:flutter_test/flutter_test.dart';
import 'package:jo_modas/models/cart_item.dart';
import 'package:jo_modas/models/product.dart';

void main() {
  final Map<String, dynamic> json = <String, dynamic>{
    'id': 'a',
    'name': 'Vestido',
    'slug': 'vestido',
    'price': '400.00',
    'promotional_price': '300.00',
    'category_id': 'c',
    'variants': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'v1',
        'product_id': 'a',
        'size': 'P',
        'color': 'Preto',
        'stock': 3,
      },
    ],
  };

  test('Product.fromJson lê decimais em texto e a promoção', () {
    final Product product = Product.fromJson(json);

    expect(product.price, 400);
    expect(product.hasPromotion, isTrue);
    expect(product.currentPrice, 300);
    expect(product.sizes, <String>['P']);
  });

  test('CartItem converte de/para JSON', () {
    const CartItem item = CartItem(
      variantId: 'v1',
      productId: 'a',
      name: 'Vestido',
      price: 400,
      promotionalPrice: 300,
      size: 'P',
      color: 'Preto',
      quantity: 2,
      stock: 3,
    );

    final CartItem copy = CartItem.fromJson(item.toJson());
    expect(copy.lineTotal, 600);
  });
}
