import '../entities/shops_warehouses.dart';

abstract class EstablishmentDatasource {
  Future<SellerConfig> getTiendasYAlmacenes();
}
