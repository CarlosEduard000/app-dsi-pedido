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
        FocusManager.instance.primaryFocus?.unfocus();

        if (ref.read(selectedItemProvider) != null) {
          ref.read(selectedItemProvider.notifier).state = null;
        }
      },
      child: child,
    );
  }
}
