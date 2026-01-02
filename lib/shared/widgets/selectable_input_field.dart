import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_input_field.dart';

class SelectableInputField extends StatelessWidget {
  final String? value;
  final String hintText;
  final IconData? icon;
  final VoidCallback onPressed;
  final String? bottomLabel;

  const SelectableInputField({
    super.key,
    this.value,
    required this.hintText,
    this.icon,
    required this.onPressed,
    this.bottomLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: AbsorbPointer(
            child: CustomInputField(
              hintText: value ?? hintText,
              prefixIcon: icon!,
              isSearchStyle: true,
            ),
          ),
        ),
        if (bottomLabel != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              bottomLabel!,
              style: GoogleFonts.roboto(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}