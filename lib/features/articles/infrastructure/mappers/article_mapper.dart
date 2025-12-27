import '../../domain/domain.dart';

class ArticleMapper {
  static Article jsonToEntity(Map<String, dynamic> json) => Article(
    id: json['id']?.toString() ?? json['c_Art']?.toString() ?? '',
    code: json['codigo']?.toString() ?? '',
    name: json['nombre']?.toString() ?? 'Sin nombre',
    unit: json['unidad_medida'] ?? json['UM'] ?? 'UNID',
    brand: json['marca'] ?? '',
    model: json['modelo'] ?? '',
    origin: json['procedencia'] ?? '',
    category: json['clase'] ?? '',
    family: json['familia'] ?? '',
    subFamily: json['subfamilia'] ?? '',
    motorNumber: json['nro_motor'] ?? '',
    dua: json['dua'] ?? '',
    price: double.tryParse(json['precio'].toString()) ?? 0.0,
    currency: json['moneda'] ?? 'PEN',
    isGift: json['isGift'] ?? false,
    quantity: json['cantidad'] ?? 0,
    image: json['imagen'],
    stock: json['stock'] ?? 0,
  );
}
