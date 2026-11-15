import '../core/constants/app_strings.dart';
import '../models/product.dart';
import '../models/product_input.dart';
import '../models/variant_input.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'product_image_service.dart';
import 'product_variant_service.dart';

/// Produtos: `GET /api/products` (paginado) e `GET /api/products/{id}`.
///
/// As mesmas rotas servem a loja e a administração: com token de admin a API
/// devolve também os produtos inativos. Por isso a loja filtra os ativos.
/// Escrita (exige token de admin): `POST /api/products`,
/// `PUT /api/products/{id}` e `DELETE /api/products/{id}`.
class ProductService {
  ProductService(this._api, this._variants, this._images);

  final ApiClient _api;
  final ProductVariantService _variants;
  final ProductImageService _images;

  static const int _relatedLimit = 6;

  /// Produtos ativos da loja, já com variações e imagens.
  Future<List<Product>> getProducts() async {
    final List<Product> all = _parseList(await _api.getAll('/products'));
    return all.where((p) => p.active).toList();
  }

  Future<Product> getProduct(String id) async {
    return _parseOne(await _api.get('/products/$id'));
  }

  /// Outros produtos da mesma categoria ("Veja também"). Usa o filtro da API,
  /// sem baixar o catálogo inteiro.
  Future<List<Product>> getRelated(Product product) async {
    final String category = Uri.encodeQueryComponent(product.categoryId);
    final dynamic data = await _api.get('/products?category_id=$category');
    final dynamic raw = data is Map<String, dynamic> ? data['data'] : data;

    return _parseList(
      raw as List<dynamic>,
    ).where((p) => p.active && p.id != product.id).take(_relatedLimit).toList();
  }

  /// Todos os produtos, inclusive os inativos (o token de admin libera).
  Future<List<Product>> getAdminProducts() async {
    return _parseList(await _api.getAll('/products'));
  }

  Future<Product> getAdminProduct(String id) => getProduct(id);

  /// Cria (sem [id]) ou atualiza o produto e depois grava estoque e fotos.
  ///
  /// Se o produto foi salvo mas uma variação ou foto falhar, lança
  /// [ApiException] avisando isso: o produto já existe e pode ser editado.
  Future<Product> saveProduct(ProductInput input, {String? id}) async {
    final Product product = _parseOne(
      id == null
          ? await _api.post('/products', body: input.toJson())
          : await _api.put('/products/$id', body: input.toJson()),
    );

    try {
      await _saveDetails(product.id, input);
    } on ApiException catch (e) {
      throw ApiException(
        '${AppStrings.productDetailsError} ${e.message}',
        statusCode: e.statusCode,
      );
    }
    return getAdminProduct(product.id);
  }

  Future<void> _saveDetails(String productId, ProductInput input) async {
    for (final String variantId in input.removedVariantIds) {
      await _variants.delete(variantId);
    }
    for (final VariantInput variant in input.variants) {
      final String? variantId = variant.id;
      if (variantId == null) {
        await _variants.create(productId, variant);
      } else {
        await _variants.updateStock(variantId, variant.stock);
      }
    }

    for (final String imageId in input.removedImageIds) {
      await _images.delete(imageId);
    }
    for (final String url in input.newImageUrls) {
      await _images.create(productId, url);
    }
  }

  Future<void> deleteProduct(String id) async {
    await _api.delete('/products/$id');
  }

  List<Product> _parseList(List<dynamic> raw) {
    return raw.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Product _parseOne(dynamic data) {
    final Map<String, dynamic> map = data as Map<String, dynamic>;
    final dynamic inner = map['data'];
    return Product.fromJson(inner is Map<String, dynamic> ? inner : map);
  }
}
