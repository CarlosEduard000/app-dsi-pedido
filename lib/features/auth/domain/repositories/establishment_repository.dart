import '../entities/shops_warehouses.dart';

abstract class EstablishmentRepository {
  Future<SellerConfig> getTiendasYAlmacenes();
}
