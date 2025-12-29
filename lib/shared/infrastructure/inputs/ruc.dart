import 'package:formz/formz.dart';

// Definimos los posibles errores
enum RucError { empty, format }

// Extendemos de FormzInput<String, RucError>
class Ruc extends FormzInput<String, RucError> {
  // Constructor para valor inicial (puro)
  const Ruc.pure() : super.pure('');

  // Constructor para cuando el usuario escribe (sucio)
  const Ruc.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == RucError.empty) return 'El campo es requerido';
    if (displayError == RucError.format) return 'Debe ser un número válido';
    return null;
  }

  @override
  RucError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return RucError.empty;

    // Validamos que sea numérico
    final isInteger = int.tryParse(value);
    if (isInteger == null) return RucError.format;

    return null;
  }
}
