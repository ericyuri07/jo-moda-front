/// Erro de autenticação já com mensagem pronta para o usuário.
class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
