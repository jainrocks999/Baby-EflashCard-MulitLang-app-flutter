import 'dart:ui';

import 'package:flutter/material.dart';

class GlassEffectContainer extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;
  final double verticalPadding;

  const GlassEffectContainer({
    super.key,
    required this.child,
    this.horizontalPadding = 12,
    this.verticalPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // bottom: 10,
      // right: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding:  EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withAlpha(81)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
