import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

final goRouterNotifierProvider = Provider((ref) {
  final notifier = GoRouterNotifier();
  
  // Escuchamos los cambios de estado del authProvider
  ref.listen(authProvider, (previous, next) {
    notifier.authStatus = next.authStatus;
  });

  return notifier;
});

class GoRouterNotifier extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.checking;

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    if (_authStatus == value) return; // Evita notificaciones innecesarias
    _authStatus = value;
    notifyListeners(); // Esto es lo que activa el 'redirect' en app_router.dart
  }
}