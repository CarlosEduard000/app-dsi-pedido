import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/features/auth/domain/datasources/auth_datasource.dart';
import 'package:app_dsi_pedido/features/auth/domain/entities/user.dart';
import 'package:app_dsi_pedido/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:app_dsi_pedido/features/auth/infrastructure/mappers/user_mapper.dart';
// Importamos el ApiResponse para usarlo en checkAuthStatus
import '../../../../shared/infrastructure/models/api_response.dart';

class AuthDatasourceImpl extends AuthDatasource {
  
  // 1. Inyectamos el Dio que viene configurado con Interceptores y URL base
  final Dio dio;

  AuthDatasourceImpl({required this.dio});

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(headers: {
          'Authorization': 'Bearer $token'
        }),
      );

      // 2. Aplicamos ApiResponse aquí (No es login, así que viene encapsulado)
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(response.data);

      if (!apiResponse.success) {
        throw CustomError(apiResponse.message ?? 'Sesión no válida');
      }

      if (apiResponse.data == null) {
        throw CustomError('No se pudo recuperar la información del usuario');
      }

      return UserMapper.userJsonToEntity(apiResponse.data!);
      
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

      // 3. EXCEPCIÓN: En login mantenemos el mapeo directo
      // (Según indicación de tu backend, esta respuesta NO usa el wrapper standard)
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
        // Intentamos leer el mensaje de error directamente del mapa de respuesta
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