class User {
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final String token;
  final String ruc;
  final int idVendedor;
  final String refreshToken;
  
  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.roles,
    required this.token,
    required this.ruc,
    this.idVendedor = 0,
    required this.refreshToken
  });

  bool get isAdmin {
    return roles.contains('admin');
  }
}
