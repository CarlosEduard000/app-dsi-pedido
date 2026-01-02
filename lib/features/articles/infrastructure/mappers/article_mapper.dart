import '../../domain/domain.dart';

class ArticleMapper {
  static Article jsonToEntity(Map<String, dynamic> json) => Article(
    id: json['id']?.toString() ?? json['c_Art']?.toString() ?? '',
    code: json['code']?.toString() ?? json['codigo']?.toString() ?? '',
    name:
        json['name']?.toString() ?? json['nombre']?.toString() ?? 'Sin nombre',
    unit:
        json['unit']?.toString() ??
        json['unidad_medida']?.toString() ??
        json['UM']?.toString() ??
        'UNID',
    brand: json['brand']?.toString() ?? json['marca']?.toString() ?? '',
    model: json['model']?.toString() ?? json['modelo']?.toString() ?? '',
    origin: json['origin']?.toString() ?? json['procedencia']?.toString() ?? '',
    category: json['category']?.toString() ?? json['clase']?.toString() ?? '',
    family: json['family']?.toString() ?? json['familia']?.toString() ?? '',
    subFamily:
        json['subFamily']?.toString() ?? json['subfamilia']?.toString() ?? '',
    motorNumber:
        json['motorNumber']?.toString() ?? json['nro_motor']?.toString() ?? '',
    dua: json['dua']?.toString() ?? '',
    price:
        double.tryParse(json['price'].toString()) ??
        double.tryParse(json['precio'].toString()) ??
        0.0,
    currency:
        json['currency']?.toString() ?? json['moneda']?.toString() ?? 'PEN',
    isGift: json['isGift'] ?? json['esGratis'] ?? false,
    quantity:
        int.tryParse(json['quantity'].toString()) ??
        int.tryParse(json['cantidad'].toString()) ??
        0,
    image: json['image'] ?? json['imagen'],
    stock: int.tryParse(json['stock'].toString()) ?? 0,
  );
}
