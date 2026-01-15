import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import '../../../../shared/shared.dart';
import '../presentation.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  final Ruc ruc;
  final Username id;
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

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Future<void> Function(int, String, String) loginUserCallback;

  LoginFormNotifier({required this.loginUserCallback})
    : super(LoginFormState());

  void onRucChange(String value) {
    final newRuc = Ruc.dirty(value);
    state = state.copyWith(
      ruc: newRuc,
      isValid: Formz.validate([newRuc, state.id, state.password]),
    );
  }

  void onIdChange(String value) {
    final newId = Username.dirty(value);
    state = state.copyWith(
      id: newId,
      isValid: Formz.validate([state.ruc, newId, state.password]),
    );
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.ruc, state.id, newPassword]),
    );
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    final int rucInt = int.tryParse(state.ruc.value) ?? 0;

    await loginUserCallback(rucInt, state.id.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final ruc = Ruc.dirty(state.ruc.value);
    final id = Username.dirty(state.id.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      ruc: ruc,
      id: id,
      password: password,
      isValid: Formz.validate([ruc, id, password]),
    );
  }
}

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
      final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

      return LoginFormNotifier(loginUserCallback: loginUserCallback);
    });
