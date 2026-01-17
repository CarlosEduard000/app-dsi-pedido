import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/config.dart';
import '../../articles.dart';

final articlePromotionsDatasourceProvider =
    Provider<ArticlesPromotionsDatasource>((ref) {
      final dio = ref.watch(dioProvider);

      return ArticlesPromotionsDatasourceImpl(dio: dio);
    });

final articlePromotionsRepositoryProvider =
    Provider<ArticlesPromotionsRepository>((ref) {
      final datasource = ref.watch(articlePromotionsDatasourceProvider);

      return ArticlesPromotionsRepositoryImpl(datasource: datasource);
    });
