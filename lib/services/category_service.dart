import '../models/category.dart';
import '../models/category_input.dart';
import 'api_client.dart';

/// Categorias.
///
/// Leitura pública: `GET /api/categories`.
/// Administração (exige token de admin): `POST /api/categories`,
/// `PUT /api/categories/{id}` e `DELETE /api/categories/{id}`. O slug é
/// gerado pelo back-end a partir do nome; categoria com produtos não pode ser
/// excluída (a API responde com a mensagem).
class CategoryService {
  CategoryService(this._api);

  final ApiClient _api;

  Future<List<Category>> getCategories() async {
    final dynamic data = await _api.get('/categories');
    final dynamic raw = data is Map<String, dynamic> ? data['data'] : data;
    return (raw as List<dynamic>)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Category> createCategory(CategoryInput input) async {
    return _parseOne(await _api.post('/categories', body: input.toJson()));
  }

  Future<Category> updateCategory(String id, CategoryInput input) async {
    return _parseOne(await _api.put('/categories/$id', body: input.toJson()));
  }

  Future<void> deleteCategory(String id) async {
    await _api.delete('/categories/$id');
  }

  Category _parseOne(dynamic data) {
    final Map<String, dynamic> map = data as Map<String, dynamic>;
    final dynamic inner = map['data'];
    return Category.fromJson(inner is Map<String, dynamic> ? inner : map);
  }
}
