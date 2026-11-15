import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:jo_modas/models/category.dart';
import 'package:jo_modas/models/category_input.dart';
import 'package:jo_modas/services/api_client.dart';
import 'package:jo_modas/services/api_exception.dart';
import 'package:jo_modas/services/category_service.dart';
import 'package:jo_modas/services/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final List<http.Request> requests = <http.Request>[];

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    requests.clear();
  });

  CategoryService serviceWith(
    Future<http.Response> Function(http.Request) handler,
  ) {
    final MockClient client = MockClient((request) {
      requests.add(request);
      return handler(request);
    });
    return CategoryService(
      ApiClient(tokenStorage: TokenStorage(), httpClient: client),
    );
  }

  http.Response json(Object body, int status) =>
      http.Response.bytes(utf8.encode(jsonEncode(body)), status);

  test('cria categoria com nome e foto', () async {
    const String photo = 'http://localhost:8021/api/uploads/foto.png';
    final CategoryService service = serviceWith(
      (_) async => json(<String, dynamic>{
        'id': 'c1',
        'name': 'Vestidos',
        'slug': 'vestidos',
        'image_url': photo,
      }, 201),
    );

    final Category category = await service.createCategory(
      const CategoryInput(name: '  Vestidos ', imageUrl: photo),
    );

    expect(category.slug, 'vestidos');
    expect(category.imageUrl, photo);
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, endsWith('/categories'));
    expect(jsonDecode(requests.single.body), <String, dynamic>{
      'name': 'Vestidos',
      'image_url': photo,
    });
  });

  test('renomeia e exclui pela rota com o id', () async {
    final CategoryService service = serviceWith(
      (request) async => request.method == 'DELETE'
          ? json(<String, dynamic>{'message': 'ok'}, 200)
          : json(<String, dynamic>{
              'id': 'c1',
              'name': 'Saias',
              'slug': 'saias',
            }, 200),
    );

    await service.updateCategory('c1', const CategoryInput(name: 'Saias'));
    await service.deleteCategory('c1');

    expect(requests.map((r) => r.method), <String>['PUT', 'DELETE']);
    expect(requests.every((r) => r.url.path.endsWith('/categories/c1')), true);
  });

  test('categoria com produtos: mostra a mensagem do back-end', () async {
    const String message =
        'Não é possível excluir uma categoria que possui produtos.';
    final CategoryService service = serviceWith(
      (_) async => json(<String, dynamic>{
        'message': message,
        'errors': <String, dynamic>{
          'category': <String>[message],
        },
      }, 422),
    );

    await expectLater(
      service.deleteCategory('c1'),
      throwsA(isA<ApiException>().having((e) => e.message, 'message', message)),
    );
  });
}
