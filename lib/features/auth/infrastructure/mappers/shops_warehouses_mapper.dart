import '../../domain/domain.dart';

class ShopsWarehousesMapper {
  static Shop jsonToShop(Map<String, dynamic> json) =>
      Shop(id: json['c_PuntoVenta'] ?? 0, name: json['nombre'] ?? 'Sin Nombre');

  static Warehouse jsonToWarehouse(Map<String, dynamic> json) => Warehouse(
    id: json['c_almacen'] ?? 0,
    name: json['nombre'] ?? 'Sin Nombre',
  );

  static SellerConfig jsonToEntity(Map<String, dynamic> json) {
    return SellerConfig(
      tiendas: (json['tienda'] as List<dynamic>? ?? [])
          .map((e) => jsonToShop(e))
          .toList(),
      almacenes: (json['almacen'] as List<dynamic>? ?? [])
          .map((e) => jsonToWarehouse(e))
          .toList(),
    );
  }
}
