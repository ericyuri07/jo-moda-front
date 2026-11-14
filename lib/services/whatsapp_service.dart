import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_config.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/formatters.dart';
import '../models/cart_item.dart';
import '../models/delivery_address.dart';

/// Monta a mensagem do pedido e abre o WhatsApp da loja (`wa.me`).
/// O pedido fecha por conversa: não há pagamento online.
class WhatsappService {
  /// Texto do pedido. [address] nulo significa retirada na loja.
  String buildMessage({
    required String customerName,
    required List<CartItem> items,
    required double total,
    DeliveryAddress? address,
  }) {
    final StringBuffer text = StringBuffer()
      ..writeln(AppStrings.orderGreeting)
      ..writeln()
      ..writeln('*${AppStrings.orderCustomer}* $customerName')
      ..writeln()
      ..writeln('*${AppStrings.orderItems}*');

    for (final CartItem item in items) {
      text.writeln(
        AppStrings.orderItemLine(
          item.quantity,
          item.name,
          item.size,
          item.color,
          Formatters.currency(item.lineTotal),
        ),
      );
    }

    text
      ..writeln()
      ..writeln('*${AppStrings.orderTotal}* ${Formatters.currency(total)}')
      ..writeln();

    if (address == null) {
      text.write('*${AppStrings.orderPickup}*');
    } else {
      text.writeln('*${AppStrings.orderDelivery}*');
      text.writeln(
        '${address.street}, ${address.number} - ${address.neighborhood}',
      );
      final String city = address.city == null ? '' : '${address.city}/';
      text.writeln('$city${address.state} - CEP ${address.cep}');

      final String? complement = address.complement;
      if (complement != null && complement.isNotEmpty) {
        text.writeln('${AppStrings.orderComplement} $complement');
      }
      final String? reference = address.reference;
      if (reference != null && reference.isNotEmpty) {
        text.write('${AppStrings.orderReference} $reference');
      }
    }

    return text.toString().trimRight();
  }

  /// Abre o WhatsApp com a mensagem pronta. Devolve `false` se não conseguiu.
  Future<bool> send(String message) async {
    final Uri uri = Uri.parse(
      'https://wa.me/${AppConfig.storeWhatsapp}'
      '?text=${Uri.encodeComponent(message)}',
    );

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object {
      return false;
    }
  }
}
