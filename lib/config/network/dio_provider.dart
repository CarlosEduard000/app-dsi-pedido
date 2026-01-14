import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_dsi_pedido/config/config.dart';
import 'dio_interceptor.dart'; 

final dioProvider = Provider<Dio>((ref) {
  
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json', // Opcional, buena práctica
      }
    ),
  );

  // Aquí conectamos el interceptor que maneja tu User.refreshToken
  dio.interceptors.add(DioInterceptor());

  return dio;
});