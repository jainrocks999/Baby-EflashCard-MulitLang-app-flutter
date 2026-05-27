import 'package:eflash_multilagnuage_upgrade/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/svgs/clouds.svg",
                fit: BoxFit.fitWidth,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/svgs/green_mountains.svg",
                fit: BoxFit.fitWidth,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
