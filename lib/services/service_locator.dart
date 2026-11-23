import 'address_service.dart';
import 'api_client.dart';
import 'auth_service.dart';
import 'cart_service.dart';
import 'category_service.dart';
import 'checkout_draft.dart';
import 'image_upload_service.dart';
import 'photo_uploader.dart';
import 'product_image_service.dart';
import 'product_service.dart';
import 'product_variant_service.dart';
import 'token_storage.dart';
import 'whatsapp_service.dart';

/// Instâncias únicas dos services. As telas importam daqui, nunca o
/// `ApiClient` diretamente.
final TokenStorage tokenStorage = TokenStorage();
final ApiClient apiClient = ApiClient(tokenStorage: tokenStorage);

final AuthService authService = AuthService(apiClient, tokenStorage);
final CategoryService categoryService = CategoryService(apiClient);
final ProductService productService = ProductService(
  apiClient,
  ProductVariantService(apiClient),
  ProductImageService(apiClient),
);
final ImageUploadService imageUploadService = ImageUploadService(apiClient);
final PhotoUploader photoUploader = PhotoUploader(imageUploadService);
final CartService cartService = CartService();
final CheckoutDraftStore checkoutDraft = CheckoutDraftStore();
final AddressService addressService = AddressService();
final WhatsappService whatsappService = WhatsappService();

/// Encerra a sessão e esvazia o carrinho salvo no aparelho.
Future<void> signOutAndClearCart() async {
  checkoutDraft.clear();
  await authService.signOut();
  await cartService.clear();
}
