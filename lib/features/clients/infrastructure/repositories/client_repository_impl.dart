import '../../domain/domain.dart';

class ClientRepositoryImpl extends ClientRepository {
  final ClientDatasource datasource;

  ClientRepositoryImpl(this.datasource);

  @override
  Future<List<Client>> getClientsByVendedor(
    int idVendedor, {
    int page = 1,
    int offset = 10,
  }) {
    return datasource.getClientsByVendedor(
      idVendedor,
      page: page,
      offset: offset,
    );
  }

  @override
  Future<Client> getClientById(int idCliente) {
    return datasource.getClientById(idCliente);
  }

  @override
  Future<List<Client>> searchClients(String query, {int offset = 10}) {
    return datasource.searchClients(query, offset: offset);
  }
}
