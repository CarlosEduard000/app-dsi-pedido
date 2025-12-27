import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/articles/presentation/presentation.dart';

class GlobalDismissKeyboard extends ConsumerWidget {
  final Widget child;

  const GlobalDismissKeyboard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 1. Quitar el foco (Cerrar teclado)
        FocusManager.instance.primaryFocus?.unfocus();

        // 2. Limpiar selección global de producto
        // Solo lo hacemos si el estado actual no es nulo para evitar repintados innecesarios
        if (ref.read(selectedItemProvider) != null) {
          ref.read(selectedItemProvider.notifier).state = null;
        }
      },
      child: child,
    );
  }
}