import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityInput extends StatelessWidget {
  final TextEditingController controller;
  final ColorScheme colors;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const QuantityInput({
    super.key,
    required this.controller,
    required this.colors,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? colors.surfaceContainerHighest : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.primary.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.isNotEmpty) {
            final intValue = int.tryParse(value) ?? 0;
            final String formattedValue = intValue.toString();

            if (value != formattedValue) {
              controller.text = formattedValue;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
            onChanged(formattedValue);
          } else {
            onChanged(value);
          }
        },
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "0",
          counterText: "",
        ),
      ),
    );
  }
}
