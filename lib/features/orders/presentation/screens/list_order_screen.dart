import 'package:app_dsi_pedido/features/orders/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/side_menu.dart';
import '../../../auth/presentation/providers/providers.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class ListOrderScreen extends ConsumerStatefulWidget {
  static const name = 'list_order';
  const ListOrderScreen({super.key});

  @override
  ConsumerState<ListOrderScreen> createState() => _ListOrderScreenState();
}

class _ListOrderScreenState extends ConsumerState<ListOrderScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if ((_scrollController.position.pixels + 400) >=
        _scrollController.position.maxScrollExtent) {
      ref.read(ordersProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final ordersState = ref.watch(ordersProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      drawerEdgeDragWidth: size.width * 0.15,
      appBar: AppBar(
        backgroundColor: colors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: colors.onSecondary),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: colors.onSecondary),
            onPressed: () => context.go('/cart_screen'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * 0.15,
            width: double.infinity,
            color: colors.secondary,
          ),
          RefreshIndicator(
            color: colors.primary,
            edgeOffset: 35,
            displacement: 50,
            notificationPredicate: (notification) {
              return notification.depth == 0;
            },
            onRefresh: () => ref.read(ordersProvider.notifier).loadOrders(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildProfileCard(
                    size,
                    colors,
                    isDark,
                    user,
                    ordersState.orders,
                    ordersState.summary,
                  ),
                  const SizedBox(height: 20),
                  if (ordersState.isLoading && ordersState.orders.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    )
                  else if (ordersState.errorMessage != null &&
                      ordersState.orders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        ordersState.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.error),
                      ),
                    ),
                  if (ordersState.isLoading && ordersState.orders.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    Size size,
    ColorScheme colors,
    bool isDark,
    dynamic user,
    List<Order> orders,
    OrderSummary? summary,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: colors.onSurface.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  'S/. ${summary?.totalAmount.toStringAsFixed(2) ?? "0.00"}',
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                Text(
                  'Monto Total Pedidos',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  user?.fullName ?? 'Usuario',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  'Vendedor ID: ${user?.idVendedor ?? 0}',
                  style: TextStyle(
                    color: colors.secondary.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Divider(thickness: 0.8),
                ),
                _buildStatsRow(colors, summary),
                const SizedBox(height: 20),
                const OrdersTableHeader(),
                const SizedBox(height: 20),
                if (orders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No hay pedidos registrados'),
                  )
                else
                  OrdersList(orders: orders.toList()),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: colors.surface,
              child: CircleAvatar(
                radius: 47,
                backgroundColor: colors.primaryContainer,
                child: Icon(Icons.person, size: 60, color: colors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ColorScheme colors, OrderSummary? summary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatItem(
          value: '${summary?.qtyAprobados ?? 0}',
          label: 'Pedidos\naprobados',
          valueColor: colors.secondary,
        ),
        StatItem(
          value: '${summary?.qtyPicking ?? 0}',
          label: 'Pedidos\nPicking',
          valueColor: colors.secondary,
        ),
        StatItem(
          value: '${summary?.qtyDespachados ?? 0}',
          label: 'Pedidos\nDespachados',
          valueColor: colors.secondary,
        ),
        StatItem(
          value: '${summary?.qtyRechazados ?? 0}',
          label: 'Pedidos\nrechazados',
          valueColor: colors.secondary,
        ),
      ],
    );
  }
}
