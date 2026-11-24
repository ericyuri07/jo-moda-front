import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:jo_modas/core/constants/app_config.dart';
import 'package:jo_modas/core/constants/app_strings.dart';
import 'package:jo_modas/core/theme/app_theme.dart';
import 'package:jo_modas/models/product.dart';
import 'package:jo_modas/models/product_input.dart';
import 'package:jo_modas/screens/admin/widgets/suggestion_picker_dialog.dart';
import 'package:jo_modas/services/api_client.dart';
import 'package:jo_modas/services/product_image_service.dart';
import 'package:jo_modas/services/product_service.dart';
import 'package:jo_modas/services/product_variant_service.dart';
import 'package:jo_modas/services/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final List<http.Request> requests = <http.Request>[];

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    requests.clear();
  });

  Map<String, dynamic> productJson(
    String id, {
    bool active = true,
    List<Map<String, dynamic>>? suggestions,
  }) => <String, dynamic>{
    'id': id,
    'name': 'Produto $id',
    'slug': 'produto-$id',
    'price': '100.00',
    'category_id': 'c1',
    'active': active,
    'suggestions': ?suggestions,
  };

  ProductService serviceReturning(Object body) {
    final ApiClient api = ApiClient(
      tokenStorage: TokenStorage(),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response.bytes(utf8.encode(jsonEncode(body)), 200);
      }),
    );
    return ProductService(
      api,
      ProductVariantService(api),
      ProductImageService(api),
    );
  }

  List<String> ids(List<Product> products) =>
      products.map((p) => p.id).toList();

  test('Veja também usa os escolhidos, sem os inativos', () async {
    final Product product = Product.fromJson(
      productJson(
        'p1',
        suggestions: <Map<String, dynamic>>[
          productJson('p3'),
          productJson('p4', active: false),
          productJson('p2'),
        ],
      ),
    );

    final List<Product> related = await serviceReturning(
      <Object>[],
    ).getRelated(product);

    expect(ids(related), <String>['p3', 'p2']);
    expect(requests, isEmpty);
  });

  test('Sem escolhidos, Veja também continua pela categoria', () async {
    final List<Product> related = await serviceReturning(<String, dynamic>{
      'data': <Object>[productJson('p1'), productJson('p2')],
    }).getRelated(Product.fromJson(productJson('p1')));

    expect(ids(related), <String>['p2']);
    expect(requests.single.url.queryParameters['category_id'], 'c1');
  });

  test('Salvar envia os sugeridos na ordem escolhida', () async {
    await serviceReturning(productJson('p1')).saveProduct(
      const ProductInput(
        name: 'Vestido',
        price: 100,
        categoryId: 'c1',
        suggestionIds: <String>['p3', 'p2'],
      ),
      id: 'p1',
    );

    final Map<String, dynamic> body =
        jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(requests.first.method, 'PUT');
    expect(body['suggestion_ids'], <String>['p3', 'p2']);
  });

  testWidgets('Janela busca, marca e respeita o limite', (tester) async {
    final List<Product> products = <Product>[
      for (int i = 0; i <= AppConfig.maxSuggestions; i++)
        Product.fromJson(productJson('n$i')),
    ];
    List<Product>? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showDialog<List<Product>>(
              context: context,
              builder: (_) => SuggestionPickerDialog(
                products: products,
                selected: products.sublist(1),
              ),
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'n0');
    await tester.pumpAndSettle();
    final Finder tile = find.byType(CheckboxListTile);
    expect(tile, findsOneWidget);
    expect(tester.widget<CheckboxListTile>(tile).onChanged, isNull);

    await tester.enterText(find.byType(TextField), 'n1');
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.enterText(find.byType(TextField), 'n0');
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.confirm));
    await tester.pumpAndSettle();

    expect(ids(result!), <String>['n2', 'n3', 'n4', 'n5', 'n6', 'n0']);
  });
}
