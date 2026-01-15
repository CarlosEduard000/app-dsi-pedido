import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/shared.dart';
import '../../../clients/presentation/providers/providers.dart';
import '../../articles.dart';

class CatalogHeader extends ConsumerWidget {
  const CatalogHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final articlesState = ref.watch(articlesProvider);
    final client = ref.watch(selectedClientProvider);

    final selectedWarehouse = ref.watch(selectedWarehouseProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableInputField(
            hintText: 'Buscar por nombre o código...',
            value: articlesState.query.isEmpty ? null : articlesState.query,
            icon: Icons.search,
            onPressed: () async {
              ref.read(articlesProvider.notifier).onSearchQueryChanged('');

              final Article? selectedArticle = await showSearch<Article?>(
                context: context,
                delegate: GlobalSearchDelegate<Article>(
                  initialData: [],
                  searchLabel: 'Buscar artículos',
                  searchFunction: (query) {
                    return ref
                        .read(articlesRepositoryProvider)
                        .getArticles(
                          query: query,
                          warehouseId: selectedWarehouse?.id ?? 0,
                        );
                  },
                  resultBuilder: (context, article, close) {
                    return ListTile(
                      leading: (article.image != null)
                          ? Image.network(
                              article.image!,
                              width: 40,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.inventory_2,
                                color: colors.onSurfaceVariant,
                              ),
                            )
                          : Icon(
                              Icons.inventory_2,
                              color: colors.onSurfaceVariant,
                            ),
                      title: Text(
                        article.name,
                        style: TextStyle(color: colors.onSurface),
                      ),
                      subtitle: Text(
                        "${article.code} - ${article.brand}",
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      trailing: Text(
                        "${article.currency == 'USD' ? '\$' : 'S/'} ${article.price.toStringAsFixed(2)}",
                        style: TextStyle(color: colors.primary),
                      ),
                      onTap: () => close(article),
                    );
                  },
                ),
              );

              if (selectedArticle != null) {
                ref
                    .read(articlesProvider.notifier)
                    .onSearchQueryChanged(selectedArticle.name);
              }
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CLIENTE SELECCIONADO',
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colors.outline,
                    ),
                  ),
                  Text(
                    client?.name ?? 'NO SELECCIONADO',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    client?.documentNumber ?? '',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.secondary,
                    ),
                  ),
                ],
              ),
              Material(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                child: IconButton(
                  icon: Icon(Icons.tune, color: colors.primary),
                  onPressed: () => context.go('/client_selection_screen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
