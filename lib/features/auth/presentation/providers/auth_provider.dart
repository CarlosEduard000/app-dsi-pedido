import 'package:flutter_riverpod/flutter_riverpod.dart';
// Asegúrate de importar tu provider de Dio
import 'package:app_dsi_pedido/config/network/dio_provider.dart';
import 'package:flutter_riverpod/legacy.dart'; 
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

// 1. PROVIDER DEL REPOSITORIO (Cadena de Inyección de Dependencias)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Obtenemos la instancia centralizada de Dio (con interceptores)
  final dio = ref.watch(dioProvider);
  
  // Inyectamos Dio al Datasource
  final datasource = AuthDatasourceImpl(dio: dio);
  
  // Inyectamos el Datasource al Repositorio
  final repository = AuthRepositoryImpl(dataSource: datasource);
  
  return repository;
});

// 2. PROVIDER DEL NOTIFIER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Leemos el repositorio ya construido correctamente arriba
  final authRepository = ref.watch(authRepositoryProvider);
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(int ruc, String id, String password) async {
    // Pequeño delay para evitar parpadeos si la respuesta es instantánea
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(ruc, id, password);
      
      // Guardamos credenciales para facilitar el próximo login (Opcional, según tu lógica de 'last_ruc')
      await keyValueStorageService.setKeyValue('last_ruc', ruc.toString());
      await keyValueStorageService.setKeyValue('last_id', id);
      
      _setLoggedUser(user);
      
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado al iniciar sesión');
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    
    // Si no hay token, cerramos sesión inmediatamente
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<Map<String, String?>> getLastCredentials() async {
    final ruc = await keyValueStorageService.getValue<String>('last_ruc');
    final id = await keyValueStorageService.getValue<String>('last_id');
    return {'ruc': ruc, 'id': id};
  }

  void _setLoggedUser(User user) async {
    // --- CAMBIO VITAL: Guardamos ambos tokens ---
    await keyValueStorageService.setKeyValue('token', user.token);
    await keyValueStorageService.setKeyValue('refreshToken', user.refreshToken);
    // --------------------------------------------

    state = state.copyWith(
      user: user,
      token: user.token, // Puedes quitar este campo del estado si ya está en user.token
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    // --- LIMPIEZA COMPLETA ---
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('refreshToken');
    // -------------------------

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      token: null,
      errorMessage: errorMessage,
    );
  }
}

// ESTADOS
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String? token; // Opcional, ya que User suele tener el token dentro
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.token,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? token,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        token: token ?? this.token,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}