import 'package:dio/dio.dart';

import '../../articles.dart';

class ArticlesPromotionsDatasourceImpl implements ArticlesPromotionsDatasource {
  final Dio dio;

  ArticlesPromotionsDatasourceImpl({required this.dio});

  @override
  Future<GiftPromotion?> getGiftPromotionByArticleId(String articleId) async {
    try {
      final response = await dio.get(
        '/articles/promotion',
        queryParameters: {'c_art': articleId},
      );

      if (response.data == null) return null;

      // Aseguramos el tipo Map para el Mapper
      final Map<String, dynamic> data = response.data is Map
          ? response.data
          : Map<String, dynamic>.from(response.data);

      // Usamos tu mapper confirmado
      return GiftPromotionMapper.jsonToEntity(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LiquidationRule?> getLiquidationRuleByArticleId(
    String articleId,
  ) async {
    try {
      final response = await dio.get(
        '/articles/liquidation',
        queryParameters: {'c_art': articleId},
      );

      if (response.data == null) return null;

      final Map<String, dynamic> data = response.data is Map
          ? response.data
          : Map<String, dynamic>.from(response.data);

      // Usamos tu mapper confirmado
      return LiquidationRuleMapper.jsonToEntity(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      return null;
    } catch (e) {
      return null;
    }
  }
}
