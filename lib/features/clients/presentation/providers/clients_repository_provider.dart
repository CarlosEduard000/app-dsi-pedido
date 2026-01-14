import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_dsi_pedido/config/network/dio_provider.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final clientsRepositoryProvider = Provider<ClientRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final datasource = ClientDatasourceImpl(dio: dio);

  return ClientRepositoryImpl(datasource);
});
