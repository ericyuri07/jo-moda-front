/// Dados enviados à API para criar ou editar uma categoria. O slug é gerado
/// pelo back-end a partir do nome.
class CategoryInput {
  const CategoryInput({required this.name, this.imageUrl});

  final String name;

  /// URL devolvida pelo upload (`POST /api/uploads`); `null` = sem foto.
  final String? imageUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name.trim(),
    'image_url': imageUrl,
  };
}
