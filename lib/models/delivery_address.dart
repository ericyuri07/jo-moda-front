/// Endereço de entrega digitado no carrinho.
class DeliveryAddress {
  const DeliveryAddress({
    required this.cep,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.state,
    this.city,
    this.complement,
    this.reference,
  });

  final String cep;
  final String street;
  final String number;
  final String neighborhood;
  final String state;
  final String? city;
  final String? complement;
  final String? reference;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'cep': cep,
    'street': street,
    'number': number,
    'neighborhood': neighborhood,
    'state': state,
    'city': city,
    'complement': complement,
    'reference': reference,
  };
}
