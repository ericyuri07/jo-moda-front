/// Variação (tamanho + cor + estoque) a gravar junto com um produto.
///
/// Sem [id] é uma variação nova (`POST /api/product-variants`); com [id] é uma
/// existente que teve o estoque alterado (`PUT /api/product-variants/{id}`).
class VariantInput {
  const VariantInput({
    required this.size,
    required this.color,
    required this.stock,
    this.id,
  });

  final String? id;
  final String size;
  final String color;
  final int stock;

  bool get isNew => id == null;

  /// Corpo do cadastro: a API exige o produto dono da variação.
  Map<String, dynamic> toJson({required String productId}) => <String, dynamic>{
    'product_id': productId,
    'size': size,
    'color': color,
    'stock': stock,
  };
}
