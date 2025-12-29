import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/config/config.dart';
import 'package:app_dsi_pedido/features/auth/domain/datasources/auth_datasource.dart';
import 'package:app_dsi_pedido/features/auth/domain/entities/user.dart';
import 'package:app_dsi_pedido/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:app_dsi_pedido/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {
  // Configuración de Dio con tiempos de espera para evitar que la app se quede colgada
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
        '/login',
        data: {
          'ruc': ruc, 
          'id': id, 
          'password': password
        },
      );

      // 1. Validar si la respuesta tiene datos. 
      // Si la API devuelve algo vacío, lanzamos error antes de mapear.
      if (response.data == null) {
        throw CustomError('El servidor no devolvió información del usuario');
      }

      // 2. Intentar mapear el usuario
      final user = UserMapper.userJsonToEntity(response.data);
      
      // 3. Validación de seguridad final: 
      // Si el mapeo devolvió un usuario pero sin token, lo tratamos como error.
      if (user.token.isEmpty) {
        throw CustomError('Respuesta de usuario inválida (sin token)');
      }

      return user;

    } on DioException catch (e) {
      // 4. Captura de errores específicos por código de estado (400, 401, 403, 500, etc.)
      if (e.response != null) {
        // Intentamos extraer el mensaje de error que envía tu API (ej: { "message": "..." })
        final String errorMessage = e.response?.data['message'] 
                                 ?? e.response?.data['error'] 
                                 ?? 'Credenciales incorrectas';
        throw CustomError(errorMessage);
      }

      // 5. Captura de errores de red (Timeout o sin internet)
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.connectionError) {
        throw CustomError('No hay conexión con el servidor');
      }

      throw CustomError('Ocurrió un error en la comunicación');

    } catch (e) {
      // 6. Captura errores de lógica (ej: falla el UserMapper)
      if (e is CustomError) rethrow;
      throw CustomError('Error al procesar la información del usuario');
    }
  }
}