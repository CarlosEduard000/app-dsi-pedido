import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../shared/shared.dart';
import '../../../clients/domain/entities/client.dart';
import 'client_order_header.dart';

class CartOrderSummary extends StatefulWidget {
  final Client? client;
  final VoidCallback onRealizarPedido;

  const CartOrderSummary({
    super.key,
    required this.client,
    required this.onRealizarPedido,
  });

  @override
  State<CartOrderSummary> createState() => _CartOrderSummaryState();
}

class _CartOrderSummaryState extends State<CartOrderSummary> {
  bool requiereAgencia = false;
  String? _selectedDestino;
  String? _selectedAfectacion;
  String? _selectedPromocion;
  String? _selectedTransportista;
  String? _selectedVencimiento;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedVencimiento =
        "${DateFormat('dd/MM/yyyy').format(DateTime.now())} (16/12/2025)";

    if (widget.client != null && widget.client!.addresses.isNotEmpty) {
      _selectedDestino = widget.client!.addresses.first;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientOrderHeader(client: widget.client),
          const Divider(height: 30, thickness: 1),
          _buildSectionTitle('Datos de entrega', colors),
          _buildDestinoField(colors),
          const SizedBox(height: 10),
          _buildVencimientoField(colors),
          const SizedBox(height: 10),
          _buildAfectacionField(),
          const SizedBox(height: 10),
          _buildPromocionField(),
          const SizedBox(height: 20),
          _buildSectionTitle('Datos de Transportista', colors),
          _buildAgenciaSwitch(colors),
          if (requiereAgencia) ...[
            const SizedBox(height: 10),
            _buildTransportistaField(),
          ],
          const SizedBox(height: 20),
          _buildSectionTitle('Observación', colors),
          CustomInputField(
            hintText: 'Nota',
            prefixIcon: Icons.note_add_outlined,
            isSearchStyle: true,
            controller: _noteController,
          ),
          const SizedBox(height: 30),
          _buildCreditStatusNew(colors),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 5),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: colors.onSurface,
        ),
      ),
    );
  }

  Widget _buildDestinoField(ColorScheme colors) {
    return SelectableInputField(
      hintText: 'Destino',
      value: _selectedDestino,
      icon: Icons.keyboard_arrow_down,
      onPressed: () async {
        final List<String> clientAddresses = widget.client?.addresses ?? [];
        final result = await showSearch<String?>(
          context: context,
          delegate: GlobalSearchDelegate<String>(
            searchLabel: 'Buscar dirección',
            initialData: clientAddresses,
            searchFunction: (query) async => clientAddresses
                .where((e) => e.toLowerCase().contains(query.toLowerCase()))
                .toList(),
            resultBuilder: (context, result, close) => ListTile(
              title: Text(result, style: TextStyle(color: colors.onSurface)),
              leading: Icon(Icons.location_on_outlined, color: colors.primary),
              onTap: () => close(result),
            ),
          ),
        );
        if (result != null) setState(() => _selectedDestino = result);
      },
    );
  }

  Widget _buildVencimientoField(ColorScheme colors) {
    return SelectableInputField(
      hintText: 'Vencimiento',
      value: _selectedVencimiento,
      icon: Icons.calendar_today_outlined,
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: colors.primary,
                  onPrimary: colors.onPrimary,
                  onSurface: colors.onSurface,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _selectedVencimiento = DateFormat('dd/MM/yyyy').format(picked);
          });
        }
      },
    );
  }

  Widget _buildAfectacionField() {
    return SelectableInputField(
      hintText: 'Afectación',
      value: _selectedAfectacion,
      icon: Icons.arrow_drop_down,
      onPressed: () {},
    );
  }

  Widget _buildPromocionField() {
    return SelectableInputField(
      hintText: 'Promoción',
      value: _selectedPromocion,
      icon: Icons.arrow_drop_down,
      onPressed: () {},
    );
  }

  Widget _buildAgenciaSwitch(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '¿Requiere una agencia?',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: colors.onSurface,
          ),
        ),
        Switch(
          value: requiereAgencia,
          onChanged: (val) => setState(() => requiereAgencia = val),
          activeColor: colors.onPrimary,
          activeTrackColor: colors.primary,
        ),
      ],
    );
  }

  Widget _buildTransportistaField() {
    return SelectableInputField(
      hintText: 'Transp.',
      value: _selectedTransportista,
      icon: Icons.local_shipping,
      onPressed: () {},
    );
  }

  Widget _buildCreditStatusNew(ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crédito disponible',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Linea asignada: S/ 100,000.00',
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Linea disponible: S/ 10,000.00',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
