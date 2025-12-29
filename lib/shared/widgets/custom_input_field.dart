import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool forceUpperCase;
  final bool isNumber;
  final bool isSearchStyle;
  final bool showPasswordVisibleButton;
  final bool showClearButton;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onFocus;
  final String? errorMessage; // <--- Nuevo campo agregado

  const CustomInputField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.forceUpperCase = true,
    this.isNumber = false,
    this.isSearchStyle = false,
    this.showPasswordVisibleButton = false,
    this.showClearButton = false,
    this.controller,
    this.onChanged,
    this.onFocus,
    this.errorMessage, // <--- Recibir en el constructor
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.isPassword;

    widget.controller?.addListener(_onTextChanged);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus && widget.onFocus != null) {
      widget.onFocus!();
    }
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller?.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Detectar si hay error para cambiar colores
    final hasError = widget.errorMessage != null;

    // Color del borde
    final borderColor = hasError 
        ? Colors.red.shade400 
        : (_isFocused ? colors.primary : colors.outline.withValues(alpha: 0.2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isFocused
                ? (isDark ? colors.surface : Colors.white)
                : (isDark
                    ? colors.surfaceVariant.withValues(alpha: 0.1)
                    : const Color(0xFFF8F9FA)),
            borderRadius: BorderRadius.circular(widget.isSearchStyle ? 10 : 8),
            border: Border.all(
              color: borderColor,
              width: _isFocused || hasError ? 1.5 : 1, // Borde más grueso si hay error
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            onChanged: widget.onChanged,
            style: GoogleFonts.roboto(color: colors.onSurface, fontSize: 15),
            keyboardType: widget.isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            textCapitalization: widget.forceUpperCase
                ? TextCapitalization.characters
                : TextCapitalization.none,
            inputFormatters: [
              if (widget.forceUpperCase && !widget.isNumber)
                UpperCaseTextFormatter(),
              if (widget.isNumber)
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: GoogleFonts.roboto(
                color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                fontSize: 15,
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: hasError
                    ? Colors.red.shade400 // Icono rojo si hay error
                    : (_isFocused
                        ? colors.primary
                        : colors.onSurfaceVariant.withValues(alpha: 0.4)),
                size: 20,
              ),
              // --- CONTENEDOR DE BOTONES DERECHOS ---
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.showClearButton &&
                      _isFocused &&
                      widget.controller != null &&
                      widget.controller!.text.isNotEmpty)
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        widget.controller?.clear();
                        if (widget.onChanged != null) widget.onChanged!('');
                      },
                    ),
                  if (widget.showPasswordVisibleButton && widget.isPassword)
                    IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: hasError ? Colors.red.shade400 : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
          ),
        ),
        
        // --- MOSTRAR MENSAJE DE ERROR ---
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              widget.errorMessage!,
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 12,
              ),
            ),
          )
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}