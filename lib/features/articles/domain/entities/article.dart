class Article {
  final String articleId;    // id o c_Art
  final String code;         // codigo
  final String name;         // nombre
  final String unit;         // unidad de medida (UM)
  final String brand;        // marca
  final String model;        // modelo
  final String origin;       // procedencia
  final String category;     // clase
  final String family;       // familia
  final String subFamily;    // subfamilia
  final String motorNumber;  // nro_motor
  final String dua;          // dua
  final double price;        // precio--------
  final String currency;     // moneda (PEN o USD)
  final List<String>activePromotions;         // tiene promociones
  // final int quantity;        // cantidad------
  final String? image;       // imagen
  final int stock;           // stock----------

  Article({
    required this.articleId,
    this.code = '',
    this.name = '',
    this.unit = 'UNID',
    this.brand = '',
    this.model = '',
    this.origin = '',
    this.category = '',
    this.family = '',
    this.subFamily = '',
    this.motorNumber = '',
    this.dua = '',
    this.price = 0.0,
    this.currency = 'PEN',
    this.activePromotions = const [],
    // this.quantity = 0,
    this.image,
    this.stock = 0,
  });
  
  Article copyWith({
    String? articleId,
    String? code,
    String? name,
    String? unit,
    String? brand,
    String? model,
    String? origin,
    String? category,
    String? family,
    String? subFamily,
    String? motorNumber,
    String? dua,
    double? price,
    String? currency,
    List<String>? activePromotions,
    // int? quantity,
    String? image,
    int? stock,
  }) => Article(
    articleId: articleId ?? this.articleId,
    code: code ?? this.code,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    origin: origin ?? this.origin,
    category: category ?? this.category,
    family: family ?? this.family,
    subFamily: subFamily ?? this.subFamily,
    motorNumber: motorNumber ?? this.motorNumber,
    dua: dua ?? this.dua,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    activePromotions: activePromotions ?? this.activePromotions,
    // quantity: quantity ?? this.quantity,
    image: image ?? this.image,
    stock: stock ?? this.stock,
  );
}