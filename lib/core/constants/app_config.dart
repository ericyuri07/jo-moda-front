import 'package:flutter/foundation.dart';

/// Configuração de ambiente e limites do app.
///
/// Os valores de ambiente vêm de `--dart-define`, então nada de endereço ou
/// telefone fica escrito nas telas (e nenhum segredo vai para o repositório):
///
/// ```
/// flutter run -d chrome
/// flutter run --dart-define=API_URL=http://192.168.0.10:8021/api
/// flutter run --dart-define=STORE_WHATSAPP=5542999998888
/// ```
abstract final class AppConfig {
  static const String _apiUrlOverride = String.fromEnvironment('API_URL');

  /// Número da loja que recebe o pedido, no formato internacional, só dígitos.
  static const String storeWhatsapp = String.fromEnvironment(
    'STORE_WHATSAPP',
    defaultValue: '5542999991773',
  );

  static const String viaCepBaseUrl = 'https://viacep.com.br/ws';

  /// Quantidade de parcelas exibida nos cards ("ou 3x de ..."). O banco ainda
  /// não tem coluna de parcelamento.
  static const int installments = 3;

  static const int maxQuantity = 99;

  /// Tempo máximo de espera por uma resposta da API ou do ViaCEP.
  static const Duration requestTimeout = Duration(seconds: 15);

  /// Foto reduzida antes do upload (o back-end aceita até 2 MB).
  static const double uploadMaxDimension = 1600;
  static const int uploadQuality = 85;

  /// URL base da API Laravel (já com `/api`).
  ///
  /// O docker-compose do back-end publica a API na porta 8021 do computador.
  /// - Chrome / Windows: `localhost` é o próprio PC.
  /// - Emulador Android: o PC é `10.0.2.2`.
  /// - Celular físico: use `--dart-define=API_URL=http://IP-DO-PC:8021/api`.
  static String get apiBaseUrl {
    if (_apiUrlOverride.isNotEmpty) return _apiUrlOverride;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8021/api';
    }
    return 'http://localhost:8021/api';
  }
}
