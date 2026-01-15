
// --- IMPORTS DE AUTH (Usuario, Entidades y Data de API) ---
import '../../../auth/auth.dart';



// Helpers para búsqueda local
Future<List<Shop>> searchLocalShops(String query, List<Shop> list) async {
  if (query.isEmpty) return list;
  return list
      .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

Future<List<Warehouse>> searchLocalWarehouses(
    String query, List<Warehouse> list) async {
  if (query.isEmpty) return list;
  return list
      .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

Future<List<String>> searchLocalStrings(
    String query, List<String> list) async {
  if (query.isEmpty) return list;
  return list
      .where((item) => item.toLowerCase().contains(query.toLowerCase()))
      .toList();
}