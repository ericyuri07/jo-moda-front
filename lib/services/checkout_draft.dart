/// Dados do carrinho já preenchidos, guardados só na memória enquanto o
/// visitante faz login para finalizar o pedido.
class CheckoutDraft {
  const CheckoutDraft({
    required this.isDelivery,
    required this.cep,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.state,
    required this.complement,
    required this.reference,
    this.city,
  });

  final bool isDelivery;
  final String cep;
  final String street;
  final String number;
  final String neighborhood;
  final String state;
  final String complement;
  final String reference;
  final String? city;
}

/// Guarda no máximo um [CheckoutDraft]; quem lê ([take]) também o descarta.
class CheckoutDraftStore {
  CheckoutDraft? _draft;

  void save(CheckoutDraft draft) => _draft = draft;

  CheckoutDraft? take() {
    final CheckoutDraft? draft = _draft;
    _draft = null;
    return draft;
  }

  void clear() => _draft = null;
}
