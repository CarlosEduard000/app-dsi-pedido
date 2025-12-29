import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final clientsRepositoryProvider = Provider<ClientRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final datasource = ClientDatasourceImpl(accessToken: accessToken);

  return ClientRepositoryImpl(datasource);
});