import 'package:intl/intl.dart';

import '../constants/app_config.dart';
import '../constants/app_strings.dart';

/// Formatação de valores para exibição e leitura de campos.
abstract final class Formatters {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  /// 300 -> "R$ 300,00"
  static String currency(double value) => _currency.format(value);

  /// "ou 3x de R$ 100,00"
  static String installment(double price) {
    return AppStrings.installmentOf(
      AppConfig.installments,
      currency(price / AppConfig.installments),
    );
  }

  /// Lê "199,90", "1.299,90" ou "199.90". Devolve `null` se não for número.
  static double? parseMoney(String text) {
    String cleaned = text.trim().replaceAll(RegExp(r'[^\d,.]'), '');
    if (cleaned.isEmpty) return null;

    if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    }
    return double.tryParse(cleaned);
  }

  /// Número para preencher campo de formulário: 199.9 -> "199,90".
  static String moneyForField(double value) =>
      value.toStringAsFixed(2).replaceAll('.', ',');

  static String digitsOnly(String text) => text.replaceAll(RegExp(r'\D'), '');

  /// "85010100" -> "85010-100"
  static String cep(String digits) {
    if (digits.length != 8) return digits;
    return '${digits.substring(0, 5)}-${digits.substring(5)}';
  }

  /// "P, M ,G" -> ["P", "M", "G"] (sem vazios nem repetidos).
  static List<String> splitList(String text) {
    final List<String> result = <String>[];
    for (final String part in text.split(',')) {
      final String item = part.trim();
      if (item.isNotEmpty && !result.contains(item)) result.add(item);
    }
    return result;
  }
}
