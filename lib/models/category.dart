/// Categoria de produto (tabela `categories`).
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String slug;

  /// Foto enviada pelo admin. Sem ela, a Home usa a foto de um produto.
  final String? imageUrl;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'slug': slug,
    'image_url': imageUrl,
  };
}
