import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/config/config.dart';
import 'package:app_dsi_pedido/features/auth/domain/datasources/auth_datasource.dart';
import 'package:app_dsi_pedido/features/auth/domain/entities/user.dart';
import 'package:app_dsi_pedido/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:app_dsi_pedido/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return UserMapper.userJsonToEntity(response.data);
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw CustomError('Sesión expirada');
      if (e.type == DioExceptionType.connectionTimeout) throw CustomError('Error de conexión');
      
      throw CustomError('No se pudo verificar el estado del usuario');
    } catch (e) {
      throw CustomError('Error inesperado al verificar autenticación');
    }
  }

  @override
  Future<User> login(int ruc, String id, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'ruc': ruc.toString(), 
          'usuario': id, 
          'pass': password
        },
      );

      if (response.data == null) {
        throw CustomError('El servidor no devolvió información del usuario');
      }

      final user = UserMapper.userJsonToEntity(response.data);
      
      if (user.token.isEmpty) {
        throw CustomError('Respuesta de usuario inválida (sin token)');
      }

      return user;

    } on DioException catch (e) {
      if (e.response != null) {
        final String errorMessage = e.response?.data['message'] 
                                 ?? e.response?.data['error'] 
                                 ?? 'Credenciales incorrectas';
        throw CustomError(errorMessage);
      }

      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.connectionError) {
        throw CustomError('No hay conexión con el servidor');
      }

      throw CustomError('Ocurrió un error en la comunicación');

    } catch (e) {
      if (e is CustomError) rethrow;
      throw CustomError('Error al procesar la información del usuario');
    }
  }
}