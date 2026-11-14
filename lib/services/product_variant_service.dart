import '../models/variant_input.dart';
import 'api_client.dart';

/// Estoque por variação (exige token de admin):
/// `POST /api/product-variants`, `PUT /api/product-variants/{id}` e
/// `DELETE /api/product-variants/{id}`.
class ProductVariantService {
  ProductVariantService(this._api);

  final ApiClient _api;

  Future<void> create(String productId, VariantInput variant) async {
    await _api.post(
      '/product-variants',
      body: variant.toJson(productId: productId),
    );
  }

  Future<void> updateStock(String variantId, int stock) async {
    await _api.put(
      '/product-variants/$variantId',
      body: <String, dynamic>{'stock': stock},
    );
  }

  Future<void> delete(String variantId) async {
    await _api.delete('/product-variants/$variantId');
  }
}
