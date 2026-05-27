import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        height: 35,
        decoration: BoxDecoration(
          color: value ? const Color(0xff7ED957) : const Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(10),
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
                      width: 23,
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
                      width: 22,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: value ? 30 : 3,
              right: value ? 3 : 30,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
