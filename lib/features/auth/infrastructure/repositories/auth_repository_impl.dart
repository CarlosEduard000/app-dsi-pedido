import 'package:app_dsi_pedido/features/auth/domain/datasources/auth_datasource.dart';
import 'package:app_dsi_pedido/features/auth/domain/entities/user.dart';
import 'package:app_dsi_pedido/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource dataSource;

  AuthRepositoryImpl({
    required this.dataSource
  }); // Eliminamos la parte de ": dataSource = dataSource ?? AuthDatasourceImpl();"

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(int ruc, String id, String password) {
    return dataSource.login(ruc, id, password);
  }
}