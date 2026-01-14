import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityInput extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onQuantityChanged;

  const QuantityInput({
    super.key,
    required this.initialValue,
    required this.onQuantityChanged,
  });

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(covariant QuantityInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      if (int.tryParse(_controller.text) != widget.initialValue) {
        _controller.text = widget.initialValue.toString();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.primary.withOpacity(0.5)),
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: "0",
          counterText: "",
        ),
        onTapOutside: (event) {
          _validateAndReset();
          FocusScope.of(context).unfocus();
        },
        onEditingComplete: () {
          _validateAndReset();
          FocusScope.of(context).unfocus();
        },
        onChanged: (value) {
          if (value.isEmpty) {
            widget.onQuantityChanged(0);
            return;
          }

          final intValue = int.tryParse(value) ?? 0;
          final String formattedValue = intValue.toString();

          if (value != formattedValue) {
            _controller.value = _controller.value.copyWith(
              text: formattedValue,
              selection: TextSelection.collapsed(offset: formattedValue.length),
            );
          }

          widget.onQuantityChanged(intValue);
        },
      ),
    );
  }

  void _validateAndReset() {
    if (_controller.text.isEmpty) {
      setState(() {
        _controller.text = "0";
      });
      widget.onQuantityChanged(0);
    }
  }
}
