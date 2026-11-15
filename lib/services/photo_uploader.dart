import 'package:image_picker/image_picker.dart';

import '../core/constants/app_config.dart';
import 'image_upload_service.dart';

/// Escolha + envio de foto usado pelas telas do admin (produto e categoria):
/// abre a galeria (ou o seletor de arquivos no navegador), reduz a foto e
/// envia pelo [ImageUploadService].
class PhotoUploader {
  PhotoUploader(this._uploads);

  final ImageUploadService _uploads;
  final ImagePicker _picker = ImagePicker();

  /// URL pública da foto enviada, ou `null` se o admin cancelou a escolha.
  /// Erros de envio chegam como `ApiException`, com a mensagem pronta.
  Future<String?> pickAndUpload() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: AppConfig.uploadMaxDimension,
      maxHeight: AppConfig.uploadMaxDimension,
      imageQuality: AppConfig.uploadQuality,
    );
    if (file == null) return null;

    return _uploads.uploadProductImage(await file.readAsBytes(), file.name);
  }
}
