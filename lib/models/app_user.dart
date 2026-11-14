/// Usuário autenticado (tabela `users`; a senha nunca chega ao app).
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = roleCustomer,
    this.address,
  });

  static const String roleAdmin = 'admin';
  static const String roleCustomer = 'customer';

  final String id;
  final String name;
  final String email;
  final String role;
  final String? address;

  bool get isAdmin => role == roleAdmin;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      role: (json['role'] as String?) ?? roleCustomer,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'address': address,
  };
}
