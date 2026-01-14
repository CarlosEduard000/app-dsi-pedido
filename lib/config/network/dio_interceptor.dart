import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/config/config.dart';

import '../../shared/shared.dart';

class DioInterceptor extends Interceptor {
  final KeyValueStorageService keyValueStorage = KeyValueStorageServiceImpl();

  final Dio dioBase = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await keyValueStorage.getValue<String>(
          'refreshToken',
        );

        if (refreshToken == null) {
          return handler.next(err);
        }

        final response = await dioBase.post(
          '/auth/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['token'];
        final newRefreshToken = response.data['refreshToken'];

        await keyValueStorage.setKeyValue('token', newAccessToken);
        await keyValueStorage.setKeyValue('refreshToken', newRefreshToken);

        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final opts = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
        );

        final cloneReq = await dioBase.request(
          err.requestOptions.path,
          options: opts,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        return handler.resolve(cloneReq);
      } catch (e) {
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}
