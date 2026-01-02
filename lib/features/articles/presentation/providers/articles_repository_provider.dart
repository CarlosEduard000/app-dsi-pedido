import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final articlesRepositoryProvider = Provider<ArticlesRepository>((ref) {
  final accessToken = ref.watch(authProvider).token ?? '';

  final repository = ArticlesRepositoryImpl(
    ArticlesDatasourceImpl(accessToken: accessToken),
  );

  return repository;
});
