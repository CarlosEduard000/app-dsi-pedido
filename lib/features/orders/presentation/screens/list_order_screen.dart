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
  
  // 1. Controlador para detectar el movimiento del Scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 2. Agregamos el "oyente" al controlador
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // 3. Limpiamos el controlador al salir
    _scrollController.dispose();
    super.dispose();
  }

  // Lógica del Infinite Scroll
  void _onScroll() {
    // Si la posición actual + 400 pixeles es mayor o igual al máximo posible...
    if ((_scrollController.position.pixels + 400) >= _scrollController.position.maxScrollExtent) {
      // Llamamos a la paginación
      ref.read(ordersProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Escuchamos el estado de los pedidos y el usuario
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
              // 4. Conectamos el controlador al ScrollView
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  
                  // Pasamos el SUMMARY para los totales y la LISTA para el detalle
                  _buildProfileCard(
                    size,
                    colors,
                    isDark,
                    user,
                    ordersState.orders,
                    ordersState.summary, // <--- CAMBIO: Pasamos el resumen
                  ),
                  const SizedBox(height: 20),

                  // Manejo de estados de la API (Carga Inicial)
                  if (ordersState.isLoading && ordersState.orders.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    )
                  else if (ordersState.errorMessage != null && ordersState.orders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        ordersState.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  
                  // 5. Indicador de carga inferior (Paginación)
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
    OrderSummary? summary, // <--- CAMBIO: Recibimos el resumen
  ) {
    
    // <--- CAMBIO: Eliminamos el cálculo manual (orders.fold)
    
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
                
                // <--- CAMBIO: Usamos summary.totalAmount
                Text(
                  // Si summary es null (cargando), mostramos 0.00
                  'S/. ${summary?.totalAmount.toStringAsFixed(2) ?? "0.00"}', 
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

                // <--- CAMBIO: Pasamos el summary en vez de orders
                _buildStatsRow(colors, summary),
                
                const SizedBox(height: 20),
                const OrdersTableHeader(), 
                const SizedBox(height: 20),
                
                // Lista de pedidos (Esto se mantiene igual, usando la lista)
                if (orders.isEmpty) // Quitamos la validación de isLoading aquí para que se vea la lista vacía si corresponde
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

  // <--- CAMBIO: Recibe OrderSummary? en lugar de List<Order>
  Widget _buildStatsRow(ColorScheme colors, OrderSummary? summary) {
    // Ya no calculamos nada aquí, solo pintamos los datos del API
    
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