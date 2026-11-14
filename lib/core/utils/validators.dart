import 'formatters.dart';

/// Validações dos formulários. Devolvem `null` quando válido e a mensagem de
/// erro quando não — o contrato que o `TextFormField` espera em `validator:`.
abstract final class Validators {
  static const int cepLength = 8;
  static const int ufLength = 2;
  static const int passwordMinLength = 6;

  static final RegExp _emailPattern = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$');
  static final RegExp _urlPattern = RegExp(r'^https?://\S+$');

  static String? required(String? value, {String field = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field é obrigatório.';
    }
    return null;
  }

  static String? email(String? value) {
    final String? empty = required(value, field: 'O e-mail');
    if (empty != null) return empty;

    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  /// Mesma regra do back-end (`min:6`).
  static String? password(String? value) {
    final String? empty = required(value, field: 'A senha');
    if (empty != null) return empty;

    if (value!.length < passwordMinLength) {
      return 'A senha precisa ter ao menos $passwordMinLength caracteres.';
    }
    return null;
  }

  static String? cep(String? value) {
    final String? empty = required(value, field: 'O CEP');
    if (empty != null) return empty;

    if (Formatters.digitsOnly(value!).length != cepLength) {
      return 'O CEP precisa ter $cepLength dígitos.';
    }
    return null;
  }

  static String? uf(String? value) {
    final String? empty = required(value, field: 'O estado');
    if (empty != null) return empty;

    if (value!.trim().length != ufLength) {
      return 'Use a sigla do estado (ex.: PR).';
    }
    return null;
  }

  static String? price(String? value) {
    final String? empty = required(value, field: 'O preço');
    if (empty != null) return empty;

    final double? parsed = Formatters.parseMoney(value!);
    if (parsed == null) return 'Informe um valor numérico.';
    if (parsed <= 0) return 'O preço precisa ser maior que zero.';
    return null;
  }

  /// Preço promocional: opcional, mas se informado precisa ser menor que o
  /// preço (a mesma regra do `ProductService` no back-end).
  static String? promotionalPrice(String? value, String? priceText) {
    if (value == null || value.trim().isEmpty) return null;

    final double? promo = Formatters.parseMoney(value);
    if (promo == null) return 'Informe um valor numérico.';
    if (promo <= 0) return 'O valor precisa ser maior que zero.';

    final double? price = Formatters.parseMoney(priceText ?? '');
    if (price != null && promo >= price) {
      return 'A promoção precisa ser menor que o preço.';
    }
    return null;
  }

  static String? optionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_urlPattern.hasMatch(value.trim())) {
      return 'Informe um endereço começando com http:// ou https://.';
    }
    return null;
  }

  /// Estoque: inteiro maior ou igual a zero.
  static String? stock(String? value) {
    final String? empty = required(value, field: 'O estoque');
    if (empty != null) return empty;

    final int? parsed = int.tryParse(value!.trim());
    if (parsed == null || parsed < 0) {
      return 'Informe um número inteiro maior ou igual a zero.';
    }
    return null;
  }
}
