import 'package:flutter/material.dart';

class PurpleBackground extends StatelessWidget {
  final double height;
  final Color color;

  const PurpleBackground({
    super.key,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: color,
    );
  }
}