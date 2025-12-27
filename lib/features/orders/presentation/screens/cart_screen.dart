import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../shared/shared.dart';
// import '../../../../shared/widgets/custom_input_field.dart';
import '../../../articles/presentation/presentation.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  static const name = 'cart_screen';
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());
  bool mostrarResumen = false;

  // En el futuro, esta lista vendrá de un 'CartProvider'
  final List<dynamic> articlesInCart = [
    // Usando estructura de entidad Article
    {'id': '1', 'title': 'ALTERNADOR CG300 18P 93MM MTF REY', 'price': 340.00, 'quantity': 10, 'code': 'ALT-CG300'},
    {'id': '3', 'title': 'AMORTIGUADOR DE BARRA DELANTERA', 'price': 450.00, 'quantity': 10, 'code': 'ALT-CG300-V2'},
  ];

  double get totalImporte => articlesInCart.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? Colors.white : const Color(0xFF333333)),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Pedido', style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20)),        
      ),
      body: Column(
        children: [
          _buildTabs(colors, isDark),
          Expanded(
            child: mostrarResumen 
              ? _viewResumen(colors, isDark, user) 
              : BuildArticleCartList(articles: articlesInCart), // Tu widget de lista
          ),
          _buildFooter(colors),
        ],
      ),
    );
  }

  Widget _viewResumen(ColorScheme colors, bool isDark, dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClientHeader(colors),
          const Divider(height: 30),
          
          // Uso del CustomInputField para los datos del resumen
          _sectionTitle(colors, 'Datos de entrega'),
          CustomInputField(
            hintText: 'Dirección o punto de llegada',
            prefixIcon: Icons.local_shipping_outlined,
            isSearchStyle: true,
          ),
          const SizedBox(height: 15),
          
          CustomInputField(
            hintText: 'Destino / Ciudad',
            prefixIcon: Icons.location_city_outlined,
            isSearchStyle: true,
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  hintText: 'Vencimiento',
                  prefixIcon: Icons.calendar_today_outlined,
                  isSearchStyle: true,
                  controller: TextEditingController(text: fechaActual),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          _sectionTitle(colors, 'Observaciones del pedido'),
          CustomInputField(
            hintText: 'Ej: Dejar en portería...',
            prefixIcon: Icons.note_add_outlined,
            isSearchStyle: true,
          ),
          
          const SizedBox(height: 30),
          _buildCreditStatus(colors),
        ],
      ),
    );
  }

  // --- Widgets de Apoyo Optimizados ---

  Widget _buildClientHeader(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CLIENTE', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            Text('INVERSIONES LA PASCANA S.A.C', style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold)),
            Text('RUC: 20503225923', style: GoogleFonts.roboto(fontSize: 12, color: colors.secondary)),
          ],
        ),
        Icon(Icons.contact_page_outlined, color: colors.primary),
      ],
    );
  }

  Widget _buildTabs(ColorScheme colors, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _tabButton(colors, 'ARTÍCULOS', !mostrarResumen),
          _tabButton(colors, 'RESUMEN', mostrarResumen),
        ],
      ),
    );
  }

  Widget _tabButton(ColorScheme colors, String text, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => mostrarResumen = (text == 'RESUMEN')),
        child: Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(text, 
            style: GoogleFonts.roboto(
              fontSize: 12, 
              fontWeight: FontWeight.bold, 
              color: active ? Colors.white : Colors.grey
            )
          ),
        ),
      ),
    );
  }

  Widget _buildCreditStatus(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.primary.withOpacity(0.1))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ESTADO DE CRÉDITO', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.bold, color: colors.primary)),
          const SizedBox(height: 5),
          Text('Disponible: S/ 10,000.00', style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _sectionTitle(ColorScheme colors, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title.toUpperCase(), style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
    );
  }

  Widget _buildFooter(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: colors.surface, 
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2))]
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _footerStat('Artículos', articlesInCart.length.toString()),
                _footerStat('Importe Total', 'S/. ${totalImporte.toStringAsFixed(2)}', isPrice: true, colors: colors),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: Text('CONFIRMAR PEDIDO', style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerStat(String label, String value, {bool isPrice = false, ColorScheme? colors}) {
    return Column(
      crossAxisAlignment: isPrice ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.roboto(fontSize: 11, color: Colors.grey)),
        Text(value, style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: isPrice ? colors?.primary : null)),
      ],
    );
  }
}