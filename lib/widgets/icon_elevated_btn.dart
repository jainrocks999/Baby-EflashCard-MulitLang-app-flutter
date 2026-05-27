import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconElevatedBtn extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final double size;
  final double elevation;
  final Color shadowColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const IconElevatedBtn({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.size = 80,
    this.elevation = 10,
    this.shadowColor = Colors.black54,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: shadowColor,
          elevation: elevation,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
        ),
      ),
    );
  }
}