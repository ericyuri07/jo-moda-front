import '../core/constants/app_strings.dart';
import 'api_client.dart';
import 'api_exception.dart';

/// Upload das fotos de produto (exige token de admin): `POST /api/uploads`.
///
/// Devolve a URL pública da foto, que depois é gravada no produto
/// (`image_url`) ou nas fotos extras (`/product-images`).
class ImageUploadService {
  ImageUploadService(this._api);

  final ApiClient _api;

  Future<String> uploadProductImage(List<int> bytes, String filename) async {
    final dynamic data = await _api.upload(
      '/uploads',
      field: 'image',
      bytes: bytes,
      filename: filename,
    );

    final Object? url = data is Map<String, dynamic> ? data['url'] : null;
    if (url is! String || url.isEmpty) {
      throw ApiException(AppStrings.unexpectedResponse);
    }
    return url;
  }
}
