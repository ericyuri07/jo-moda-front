import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_sizes.dart';
import '../../services/service_locator.dart';

/// Escolha + envio de foto usado pelas telas do admin (produto e categoria):
/// abre a galeria (ou o seletor de arquivos no navegador), reduz a foto e
/// envia pelo `ImageUploadService`.
class PhotoUploader {
  final ImagePicker _picker = ImagePicker();

  /// URL pública da foto enviada, ou `null` se o admin cancelou a escolha.
  /// Erros de envio chegam como `ApiException`, com a mensagem pronta.
  Future<String?> pickAndUpload() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: AppSizes.uploadMaxDimension,
      maxHeight: AppSizes.uploadMaxDimension,
      imageQuality: AppSizes.uploadQuality,
    );
    if (file == null) return null;

    return imageUploadService.uploadProductImage(
      await file.readAsBytes(),
      file.name,
    );
  }
}
