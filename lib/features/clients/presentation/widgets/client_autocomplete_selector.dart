import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/shared.dart';
import '../../domain/entities/client.dart';
import '../providers/providers.dart';

class ClientAutocompleteSelector extends ConsumerStatefulWidget {
  const ClientAutocompleteSelector({super.key});

  @override
  ConsumerState<ClientAutocompleteSelector> createState() =>
      _ClientAutocompleteSelectorState();
}

class _ClientAutocompleteSelectorState
    extends ConsumerState<ClientAutocompleteSelector> {
  Iterable<Client> _lastOptions = [];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Leemos el repositorio directamente
    final clientRepository = ref.read(clientsRepositoryProvider);

    return Autocomplete<Client>(
      // 1. Lógica de Búsqueda
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final query = textEditingValue.text;

        if (query.trim().isEmpty) return const Iterable<Client>.empty();

        // Debounce para no saturar la API
        await Future.delayed(const Duration(milliseconds: 400));

        if (textEditingValue.text != query) return _lastOptions;

        try {
          final results = await clientRepository.searchClients(query);
          _lastOptions = results;
          return results;
        } catch (e) {
          return const Iterable<Client>.empty();
        }
      },

      displayStringForOption: (Client option) => option.name,

      // 2. CORRECCIÓN CRÍTICA PARA EL BLOQUEO (ANR)
      onSelected: (Client selection) {
        FocusScope.of(context).unfocus();

        // 2. Usamos Timer.run para sacar la actualización del estado del ciclo de vida 
        // actual del Autocomplete. Esto evita el bloqueo del hilo principal.
        WidgetsBinding.instance.addPostFrameCallback((_) {
        // Verificamos si el widget sigue existiendo antes de actuar
          if (!mounted) return;
          
          // Actualizamos el proveedor global
          ref.read(selectedClientProvider.notifier).state = selection;
        });
      },

      // 3. Diseño del Input
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return CustomInputField(
              hintText: 'Buscar cliente...',
              prefixIcon: Icons.person_search_outlined,
              isSearchStyle: true,
              controller: textEditingController,
              focusNode: focusNode,
              showClearButton: true,
            );
          },

      // 4. Diseño de la Lista
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              constraints: const BoxConstraints(maxHeight: 250),
              color: colors.surface,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final Client option = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      option.name,
                      style: GoogleFonts.roboto(fontSize: 14),
                    ),
                    subtitle: Text(
                      option.documentNumber,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
