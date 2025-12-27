import 'package:app_dsi_pedido/features/auth/domain/datasources/auth_datasource.dart';
import 'package:app_dsi_pedido/features/auth/domain/entities/user.dart';
import 'package:app_dsi_pedido/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_dsi_pedido/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource dataSource;

  AuthRepositoryImpl({
    AuthDatasource? dataSource
  }) :  dataSource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(int ruc, String id, String password) {
    return dataSource.login(ruc, id, password);
  }
}