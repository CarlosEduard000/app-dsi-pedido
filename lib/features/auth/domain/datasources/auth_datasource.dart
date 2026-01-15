import '../entities/user.dart';

abstract class AuthDatasource {
  Future<User> login(int ruc, String id, String password);
  Future<User> checkAuthStatus(String token);
}
