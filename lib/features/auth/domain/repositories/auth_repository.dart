import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(int ruc, String id, String password);
  Future<User> checkAuthStatus(String token);
}
