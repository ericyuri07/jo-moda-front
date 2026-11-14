import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_config.dart';
import '../core/theme/app_sizes.dart';
import 'api_exception.dart';
import 'token_storage.dart';

/// Cliente HTTP único do app: monta a URL, envia o token do Sanctum e traduz
/// os erros do Laravel (422 de validação, 401, 403, 404, 500...).
class ApiClient {
  ApiClient({required TokenStorage tokenStorage, http.Client? httpClient})
    : _tokenStorage = tokenStorage,
      _http = httpClient ?? http.Client();

  final TokenStorage _tokenStorage;
  final http.Client _http;

  /// Chamado quando uma requisição **com token** volta 401 (token expirado ou
  /// revogado). O `AuthService` usa isso para encerrar a sessão.
  Future<void> Function()? onUnauthorized;

  Future<dynamic> get(String path) => _send('GET', path);

  /// Lista completa de uma rota paginada do Laravel (`paginate()` devolve
  /// `{"data": [...], "current_page": 1, "last_page": 3, ...}`): busca todas
  /// as páginas e junta os itens. Uma lista pura (`[...]`) volta como está.
  Future<List<dynamic>> getAll(String path) async {
    final String separator = path.contains('?') ? '&' : '?';
    final List<dynamic> items = <dynamic>[];
    int page = 1;

    while (true) {
      final dynamic data = await get('$path${separator}page=$page');
      if (data is List<dynamic>) return data;

      final Map<String, dynamic> map = data as Map<String, dynamic>;
      items.addAll(map['data'] as List<dynamic>);

      final int lastPage = (map['last_page'] as num?)?.toInt() ?? page;
      if (page >= lastPage) return items;
      page++;
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) =>
      _send('POST', path, body: body);

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) =>
      _send('PUT', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  /// Envia um arquivo (`multipart/form-data`) no campo [field].
  Future<dynamic> upload(
    String path, {
    required String field,
    required List<int> bytes,
    required String filename,
  }) async {
    final http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse('${AppConfig.apiBaseUrl}$path'))
          ..files.add(
            http.MultipartFile.fromBytes(field, bytes, filename: filename),
          );
    return _dispatch(request);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) {
    final http.Request request = http.Request(
      method,
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
    )..headers['Content-Type'] = 'application/json';
    if (body != null) request.body = jsonEncode(body);
    return _dispatch(request);
  }

  /// Envio comum a JSON e upload: token, tempo limite, 401 e erros de rede.
  Future<dynamic> _dispatch(http.BaseRequest request) async {
    final String? token = await _tokenStorage.read();
    request.headers['Accept'] = 'application/json';
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    try {
      final http.StreamedResponse streamed = await _http
          .send(request)
          .timeout(AppDurations.requestTimeout);
      final http.Response response = await http.Response.fromStream(streamed);

      if (response.statusCode == 401 && token != null) {
        await onUnauthorized?.call();
      }
      return _handle(response);
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder. Tente novamente.');
    } on http.ClientException {
      throw ApiException(
        'Não foi possível conectar ao servidor. '
        'Confira sua conexão e se o back-end está rodando.',
      );
    }
  }

  dynamic _handle(http.Response response) {
    final String raw = utf8.decode(response.bodyBytes);

    dynamic decoded;
    if (raw.isNotEmpty) {
      try {
        decoded = jsonDecode(raw);
      } on FormatException {
        decoded = null;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw ApiException(
      _errorMessage(decoded, response.statusCode),
      statusCode: response.statusCode,
    );
  }

  /// O Laravel responde erros de validação assim:
  /// `{"message": "...", "errors": {"email": ["E-mail ou senha inválidos."]}}`
  String _errorMessage(dynamic decoded, int status) {
    if (decoded is Map<String, dynamic>) {
      final dynamic errors = decoded['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final dynamic first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
      }

      final dynamic message = decoded['message'];
      if (message is String && message.isNotEmpty) return message;
    }

    return switch (status) {
      401 => 'Sessão expirada. Faça login novamente.',
      403 => 'Você não tem permissão para esta ação.',
      404 => 'Conteúdo não encontrado.',
      >= 500 => 'Erro no servidor. Tente novamente mais tarde.',
      _ => 'Não foi possível concluir a operação.',
    };
  }
}
