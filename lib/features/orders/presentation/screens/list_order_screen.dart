import 'package:app_dsi_pedido/features/orders/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/side_menu.dart';
import '../../../auth/presentation/providers/providers.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart'; // Tu archivo de barril

class ListOrderScreen extends ConsumerStatefulWidget {
  static const name = 'list_order';
  const ListOrderScreen({super.key});

  @override
  ConsumerState<ListOrderScreen> createState() => _ListOrderScreenState();
}

class _ListOrderScreenState extends ConsumerState<ListOrderScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Escuchamos el estado de los pedidos y el usuario
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
          icon: Icon(Icons.menu, color: isDark ? Colors.black : Colors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: isDark ? Colors.black : Colors.white,
            ),
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
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Pasamos la lista de pedidos directamente
                  _buildProfileCard(
                    size,
                    colors,
                    isDark,
                    user,
                    ordersState.orders,
                  ),
                  const SizedBox(height: 20),

                  // Manejo de estados de la API
                  if (ordersState.isLoading && ordersState.orders.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    )
                  else if (ordersState.errorMessage != null)
                    Text(ordersState.errorMessage!),
                  // else
                  //   Column(
                  //     children: [
                  //       //_buildTableHeader(),
                  //       // _buildOrdersList(ordersState.orders, colors, isDark),
                  //     ],
                  //   ),
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
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  'S/. 0.00', // Podrías calcular el total recorriendo la lista 'orders'
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                Text(
                  'Monto Total Pedidos',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 15),
                Text(
                  user?.fullName ?? 'Usuario',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : colors.secondary,
                  ),
                ),
                Text(
                  'Vendedor ID: ${user?.idVendedor ?? 0}',
                  style: TextStyle(
                    color: colors.secondary.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Divider(thickness: 0.5),
                ),
                _buildStatsRow(colors),
                const SizedBox(height: 20),
                OrdersTableHeader(),
                const SizedBox(height: 20),
                // Aquí usamos 'orders' que es la lista recibida por parámetro
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

  Widget _buildStatsRow(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatItem(
          value: '12',
          label: 'Pedidos\naprobados',
          valueColor: colors.secondary,
        ),
        StatItem(
          value: '24',
          label: 'Pedidos\nPicking',
          valueColor: colors.secondary,
        ),
        StatItem(
          value: '35',
          label: 'Pedidos\nDespachados',
          valueColor: colors.secondary,
        ),
        StatItem(
          value: '1',
          label: 'Pedidos\nrechazados',
          valueColor: colors.secondary,
        ),
      ],
    );
  }
}
