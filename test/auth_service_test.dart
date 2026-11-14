import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:jo_modas/core/constants/app_strings.dart';
import 'package:jo_modas/services/api_client.dart';
import 'package:jo_modas/services/auth_service.dart';
import 'package:jo_modas/services/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API falsa: o login devolve um usuário com o [role] pedido e registra se
/// o logout (revogação do token) foi chamado.
class _FakeApi {
  _FakeApi(this.role);

  final String role;
  bool loggedOut = false;

  http.Client get client => MockClient((request) async {
    if (request.url.path.endsWith('/auth/login')) {
      return http.Response(
        jsonEncode(<String, dynamic>{
          'user': <String, dynamic>{
            'id': 'u1',
            'name': 'Teste',
            'email': 'teste@jomodas.com',
            'role': role,
          },
          'token': 'token-123',
        }),
        200,
      );
    }
    if (request.url.path.endsWith('/auth/logout')) {
      loggedOut = true;
      return http.Response('{"message":"ok"}', 200);
    }
    return http.Response('{}', 404);
  });
}

void main() {
  late TokenStorage tokens;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tokens = TokenStorage();
  });

  AuthService serviceFor(_FakeApi api) => AuthService(
    ApiClient(tokenStorage: tokens, httpClient: api.client),
    tokens,
  );

  test('login de cliente aceita conta de cliente', () async {
    final _FakeApi api = _FakeApi('customer');
    final AuthService auth = serviceFor(api);

    await auth.signIn(email: 'teste@jomodas.com', password: '123456');

    expect(auth.isSignedIn, isTrue);
    expect(auth.isAdmin, isFalse);
    expect(await tokens.read(), 'token-123');
  });

  test('login de cliente recusa conta ADM e revoga o token', () async {
    final _FakeApi api = _FakeApi('admin');
    final AuthService auth = serviceFor(api);

    await expectLater(
      auth.signIn(email: 'teste@jomodas.com', password: '123456'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          AppStrings.useAdminLogin,
        ),
      ),
    );
    expect(auth.isSignedIn, isFalse);
    expect(api.loggedOut, isTrue);
    expect(await tokens.read(), isNull);
  });

  test('login ADM aceita conta ADM', () async {
    final AuthService auth = serviceFor(_FakeApi('admin'));

    await auth.signInAdmin(email: 'teste@jomodas.com', password: '123456');

    expect(auth.isAdmin, isTrue);
  });

  test('login ADM recusa conta de cliente', () async {
    final _FakeApi api = _FakeApi('customer');
    final AuthService auth = serviceFor(api);

    await expectLater(
      auth.signInAdmin(email: 'teste@jomodas.com', password: '123456'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          AppStrings.notAdminAccount,
        ),
      ),
    );
    expect(auth.isSignedIn, isFalse);
    expect(api.loggedOut, isTrue);
  });
}
