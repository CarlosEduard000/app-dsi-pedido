import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_dsi_pedido/config/network/dio_provider.dart';

import '../../domain/domain.dart';
import '../datasources/establishment_datasource_impl.dart';

class EstablishmentRepositoryImpl extends EstablishmentRepository {
  final EstablishmentDatasource datasource;

  EstablishmentRepositoryImpl(this.datasource);

  @override
  Future<SellerConfig> getTiendasYAlmacenes() {
    return datasource.getTiendasYAlmacenes();
  }
}

final establishmentRepositoryProvider = Provider<EstablishmentRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  final datasource = EstablishmentDatasourceImpl(dio: dio);
  return EstablishmentRepositoryImpl(datasource);
});

final establishmentsProvider = FutureProvider<SellerConfig>((ref) async {
  final repository = ref.watch(establishmentRepositoryProvider);
  return repository.getTiendasYAlmacenes();
});
