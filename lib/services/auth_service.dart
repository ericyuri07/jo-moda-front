import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';
import '../models/app_user.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'token_storage.dart';

/// Erro de autenticação já com mensagem pronta para o usuário.
class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Autenticação contra o Laravel + Sanctum.
///
/// - `POST /api/auth/register` e `POST /api/auth/login` -> `{ "user": {...}, "token": "..." }`
/// - `POST /api/auth/logout` e `GET /api/auth/me` (exigem o token)
///
/// É um `ChangeNotifier`: o router escuta este service e redireciona sozinho
/// quando o usuário entra, sai ou tem a sessão expirada.
class AuthService extends ChangeNotifier {
  AuthService(this._api, this._tokens) {
    _api.onUnauthorized = _expireSession;
  }

  final ApiClient _api;
  final TokenStorage _tokens;

  AppUser? _current;

  AppUser? get currentUser => _current;

  bool get isSignedIn => _current != null;

  bool get isAdmin => _current?.isAdmin ?? false;

  /// Login de cliente. Conta de administrador é recusada: ela entra pelo
  /// login ADM ([signInAdmin]).
  Future<AppUser> signIn({required String email, required String password}) {
    return _authenticate('/auth/login', <String, dynamic>{
      'email': email.trim(),
      'password': password,
    }, expectAdmin: false);
  }

  /// Login de administrador. Conta de cliente é recusada.
  Future<AppUser> signInAdmin({
    required String email,
    required String password,
  }) {
    return _authenticate('/auth/login', <String, dynamic>{
      'email': email.trim(),
      'password': password,
    }, expectAdmin: true);
  }

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _authenticate('/auth/register', <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
    });
  }

  /// Cria um administrador (`POST /api/auth/register-admin`). O back-end só
  /// aceita com o código de acesso certo.
  Future<AppUser> signUpAdmin({
    required String name,
    required String email,
    required String password,
    required String adminCode,
  }) {
    return _authenticate('/auth/register-admin', <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'admin_code': adminCode.trim(),
    });
  }

  /// [expectAdmin] (quando informado) exige o tipo de conta da tela de login:
  /// se não bater, o token recém-criado é revogado e nada fica logado.
  Future<AppUser> _authenticate(
    String path,
    Map<String, dynamic> body, {
    bool? expectAdmin,
  }) async {
    final Map<String, dynamic> data;
    final AppUser user;
    try {
      data = (await _api.post(path, body: body)) as Map<String, dynamic>;
      user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } on TypeError {
      // JSON em formato diferente do esperado (campo faltando ou de outro tipo).
      throw AuthException(AppStrings.unexpectedResponse);
    }

    final Object? token = data['token'];
    if (token is! String) throw AuthException(AppStrings.unexpectedResponse);

    await _tokens.save(token);

    if (expectAdmin != null && user.isAdmin != expectAdmin) {
      await _revokeCurrentToken();
      throw AuthException(
        expectAdmin ? AppStrings.notAdminAccount : AppStrings.useAdminLogin,
      );
    }

    _setUser(user);
    return user;
  }

  /// Revoga no back-end o token salvo e apaga do aparelho, sem avisar o
  /// router (ninguém chegou a ficar logado).
  Future<void> _revokeCurrentToken() async {
    try {
      await _api.post('/auth/logout');
    } on ApiException {
      // Sem rede: o token só fica esquecido no servidor.
    } finally {
      await _tokens.clear();
    }
  }

  Future<void> signOut() async {
    try {
      await _api.post('/auth/logout');
    } on ApiException {
      // Sem rede ou token já inválido: o logout local acontece de qualquer jeito.
    } finally {
      await _tokens.clear();
      _setUser(null);
    }
  }

  /// Ao abrir o app: se houver token salvo e válido, restaura o login.
  /// Nunca lança: qualquer falha só significa "abrir deslogado".
  Future<AppUser?> restoreSession() async {
    final String? token = await _tokens.read();
    if (token == null) return null;

    try {
      final Map<String, dynamic> data =
          (await _api.get('/auth/me')) as Map<String, dynamic>;
      // Aceita o usuário puro ou embrulhado em `{"user": {...}}`.
      final Object? inner = data['user'];
      final AppUser user = AppUser.fromJson(
        inner is Map<String, dynamic> ? inner : data,
      );
      _setUser(user);
      return user;
    } on ApiException {
      // Um 401 já limpou o token (via _expireSession). Sem rede, o token fica
      // guardado para tentar de novo na próxima abertura.
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> _expireSession() async {
    await _tokens.clear();
    _setUser(null);
  }

  void _setUser(AppUser? user) {
    _current = user;
    notifyListeners();
  }
}
