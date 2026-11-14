import 'api_client.dart';

/// Fotos extras do produto (exige token de admin):
/// `POST /api/product-images` e `DELETE /api/product-images/{id}`.
class ProductImageService {
  ProductImageService(this._api);

  final ApiClient _api;

  Future<void> create(String productId, String imageUrl) async {
    await _api.post(
      '/product-images',
      body: <String, dynamic>{'product_id': productId, 'image_url': imageUrl},
    );
  }

  Future<void> delete(String imageId) async {
    await _api.delete('/product-images/$imageId');
  }
}
