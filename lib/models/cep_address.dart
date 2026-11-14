/// Endereço devolvido pela consulta de CEP (ViaCEP).
class CepAddress {
  const CepAddress({
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  final String street;
  final String neighborhood;
  final String city;
  final String state;

  factory CepAddress.fromJson(Map<String, dynamic> json) {
    return CepAddress(
      street: (json['logradouro'] as String?) ?? '',
      neighborhood: (json['bairro'] as String?) ?? '',
      city: (json['localidade'] as String?) ?? '',
      state: (json['uf'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'logradouro': street,
    'bairro': neighborhood,
    'localidade': city,
    'uf': state,
  };
}
