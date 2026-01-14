import 'package:flutter_riverpod/flutter_riverpod.dart';
// IMPORTANTE: Importa tu dio_provider
import 'package:app_dsi_pedido/config/network/dio_provider.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final articlesRepositoryProvider = Provider<ArticlesRepository>((ref) {
  
  // 1. Obtenemos la instancia centralizada de Dio
  final dio = ref.watch(dioProvider);

  // 2. Creamos el Datasource inyectándole Dio (ya no accessToken)
  final datasource = ArticlesDatasourceImpl(dio: dio);

  // 3. Creamos el Repositorio
  final repository = ArticlesRepositoryImpl(datasource);

  return repository;
});