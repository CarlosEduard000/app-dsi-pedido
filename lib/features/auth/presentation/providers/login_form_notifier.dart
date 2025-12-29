import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import '../../../../shared/shared.dart';
import '../presentation.dart'; 

//! 1 - State del Provider
// El estado mantiene los Inputs de Formz.
// Aunque tu User Entity tiene un Ruc int, el formulario maneja "Inputs" (Strings)
// que luego convertiremos.
class LoginFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  
  // Usamos las clases Inputs definidas en shared/infrastructure/inputs/
  final Ruc ruc; 
  final Username id;      // Mapea al campo 'id' de tu User
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.ruc = const Ruc.pure(),
    this.id = const Username.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Ruc? ruc,
    Username? id,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    ruc: ruc ?? this.ruc,
    id: id ?? this.id,
    password: password ?? this.password,
  );

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    ruc: $ruc
    id: $id
    password: $password
''';
  }
}

//! 2 - Notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {

  // La función de callback debe coincidir con la firma del AuthProvider:
  // loginUser(int ruc, String id, String password)
  final Future<void> Function(int, String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback,
  }): super( LoginFormState() );

  // --- Cambio de RUC ---
  void onRucChange( String value ) {
    final newRuc = Ruc.dirty(value);
    state = state.copyWith(
      ruc: newRuc,
      isValid: Formz.validate([ newRuc, state.id, state.password ])
    );
  }

  // --- Cambio de ID ---
  void onIdChange( String value ) {
    final newId = Username.dirty(value);
    state = state.copyWith(
      id: newId,
      isValid: Formz.validate([ state.ruc, newId, state.password ])
    );
  }

  // --- Cambio de Password ---
  void onPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ state.ruc, state.id, newPassword ])
    );
  }

  // --- Submit del Formulario ---
  Future<void> onFormSubmit() async {
    _touchEveryField();

    if ( !state.isValid ) return;

    state = state.copyWith(isPosting: true);

    // AQUÍ OCURRE LA MAGIA:
    // Tu Textfield entrega un String, pero tu User Entity y AuthProvider piden un INT.
    // Hacemos la conversión antes de enviar.
    final int rucInt = int.tryParse(state.ruc.value) ?? 0;

    await loginUserCallback( 
      rucInt,             // int (Coincide con User.ruc)
      state.id.value,     // String (Coincide con User.id)
      state.password.value // String (Input de formulario)
    );

    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final ruc      = Ruc.dirty(state.ruc.value);
    final id       = Username.dirty(state.id.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      ruc: ruc,
      id: id,
      password: password,
      isValid: Formz.validate([ ruc, id, password ])
    );
  }
}

//! 3 - StateNotifierProvider
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  
  // Consumimos el método del AuthProvider
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFormNotifier(
    loginUserCallback: loginUserCallback
  );
});