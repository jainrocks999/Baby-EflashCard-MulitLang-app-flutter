import 'package:baby_flash_apps/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);

    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: ResponsiveUtils.width(context, isTablet?12:15),
        
        height: ResponsiveUtils.height(context, isTablet?4:4.5),
        decoration: BoxDecoration(
          color: value ? const Color(0xff7ED957) : const Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, isTablet?1:2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Stack(
          alignment: Alignment.center,
          children: [
            value
                ? Positioned(
                    left: 5,
                    child: SvgPicture.asset(
                      "assets/svgs/check.svg",
                      width: ResponsiveUtils.width(context, isTablet?3.8:5.8),
                      colorFilter: const ColorFilter.mode(
                        Colors.green,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : Positioned(
                    right: 5,
                    child: SvgPicture.asset(
                      "assets/svgs/cross.svg",
                      width: ResponsiveUtils.width(context, isTablet?3.8:5),
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: value ? ResponsiveUtils.width(context, isTablet?6:7.8) : ResponsiveUtils.width(context, isTablet?1:1.3),
              right: value ? ResponsiveUtils.width(context, isTablet?1:1.3) : ResponsiveUtils.width(context, isTablet?6:7.8),

              child: Container(
               width: ResponsiveUtils.width(context, isTablet?9:7.8),
                height: ResponsiveUtils.height(context, isTablet?3.2:3.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, isTablet?1:1.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
