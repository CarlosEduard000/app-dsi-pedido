import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/shared.dart';
import '../../../articles/presentation/widgets/build_article_cart_list.dart';
import '../../../clients/presentation/providers/providers.dart';
import '../../presentation/providers/order_draft_provider.dart';

import '../widgets/widgets.dart';

class CartScreen extends ConsumerStatefulWidget {
  static const name = 'cart_screen';
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool mostrarResumen = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final orderDraft = ref.watch(orderDraftProvider);
    final selectedClient = ref.watch(selectedClientProvider);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: _buildAppBar(colors, orderDraft),
      body: Column(
        children: [
          CartTabsSelector(
            isSummaryView: mostrarResumen,
            onTabChanged: (isSummary) =>
                setState(() => mostrarResumen = isSummary),
          ),
          Expanded(
            child: mostrarResumen
                ? CartOrderSummary(
                    client: selectedClient,
                    onRealizarPedido: () {},
                  )
                : BuildArticleCartList(
                    orderItems: orderDraft.items.values.toList(),
                  ),
          ),
          CartBottomBar(
            draft: orderDraft,
            isSummaryView: mostrarResumen,
            onContinue: () => setState(() => mostrarResumen = true),
            onConfirm: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido Realizado con éxito')),
              );
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ColorScheme colors, OrderDraftState orderDraft) {
    return AppBar(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: colors.onSurface),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      title: Text(
        mostrarResumen ? 'Carrito' : 'Pedido (${orderDraft.totalItems} items)',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: colors.onSurface,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {},
          color: colors.secondary,
        ),
      ],
    );
  }
}
