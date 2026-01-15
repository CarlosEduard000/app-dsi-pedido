class Shop {
  final int id;
  final String name;

  Shop({required this.id, required this.name});
}

class Warehouse {
  final int id;
  final String name;

  Warehouse({required this.id, required this.name});
}

class SellerConfig {
  final List<Shop> tiendas;
  final List<Warehouse> almacenes;

  SellerConfig({required this.tiendas, required this.almacenes});
}
