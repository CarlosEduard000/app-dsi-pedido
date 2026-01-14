import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/config/config.dart';

import '../../shared/shared.dart';

class DioInterceptor extends Interceptor {
  // Servicio para leer/escribir tokens en la memoria del celular
  final KeyValueStorageService keyValueStorage = KeyValueStorageServiceImpl();
  
  // Instancia auxiliar de Dio SOLO para el refresh (evita bucles infinitos con el interceptor principal)
  final Dio dioBase = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Antes de cada petición, pegamos el TOKEN DE ACCESO si existe
    final token = await keyValueStorage.getValue<String>('token');
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 2. Si el servidor responde 401 (Unauthorized), intentamos usar el Refresh Token
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await keyValueStorage.getValue<String>('refreshToken');
        
        // Si no hay refresh token guardado, no podemos hacer nada -> Logout
        if (refreshToken == null) {
          return handler.next(err); 
        }

        // 3. Pedimos renovación al Backend
        // Ajusta la URL '/auth/refresh-token' según tu backend real
        final response = await dioBase.post('/auth/refresh-token', data: {
          'refreshToken': refreshToken
        });

        // 4. Extraemos los nuevos tokens de la respuesta
        // NOTA: Asegúrate que estas llaves ('token', 'refreshToken') coincidan con tu backend
        final newAccessToken = response.data['token']; 
        final newRefreshToken = response.data['refreshToken']; 
        
        // 5. Guardamos los nuevos tokens en el Storage para el futuro
        await keyValueStorage.setKeyValue('token', newAccessToken);
        await keyValueStorage.setKeyValue('refreshToken', newRefreshToken);

        // 6. Corregimos la petición original que falló con el nuevo token
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        
        final opts = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
        );

        // 7. Reintentamos la petición original
        final cloneReq = await dioBase.request(
          err.requestOptions.path,
          options: opts,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        return handler.resolve(cloneReq);

      } catch (e) {
        // Si el refresh token también venció o falló -> Dejamos pasar el error (Logout forzoso)
        return handler.next(err);
      }
    }
    
    handler.next(err);
  }
}