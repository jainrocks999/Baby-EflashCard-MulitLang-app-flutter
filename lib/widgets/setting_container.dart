import 'package:flutter/material.dart';

class SettingContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double borderRadius;

  const SettingContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.color = Colors.white,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
