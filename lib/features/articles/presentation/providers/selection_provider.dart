import 'package:app_dsi_pedido/features/articles/domain/entities/article.dart';
import 'package:flutter_riverpod/legacy.dart';

// Ahora el provider sabe que guardará un objeto Producto completo
final selectedItemProvider = StateProvider<Article?>((ref) => null);