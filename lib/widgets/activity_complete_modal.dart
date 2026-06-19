import 'package:baby_flash_apps/core/constants/category.dart';
import 'package:baby_flash_apps/core/utils/responsive.dart';
import 'package:baby_flash_apps/router/route_paths.dart';
import 'package:baby_flash_apps/widgets/icon_elevated_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActivityCompleteModal extends StatelessWidget {
  const ActivityCompleteModal({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        if (result == null && context.mounted) {
          context.go(RoutePaths.home);
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20),
        child: Container(
          height: 300,
          padding: EdgeInsets.symmetric(vertical: 55, horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xfff7cd89),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    'Completed'.toUpperCase(),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        isTablet ? 6 : 7.5,
                      ),
                      fontFamily: "Fredoka",
                      fontWeight: FontWeight.w700,
                      // color: Color(0xff825c2f),
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.done_outline_rounded,
                      color: Colors.white60,
                      size: ResponsiveUtils.width(context, isTablet ? 5 : 6),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 5,
                children: [
                  IconElevatedBtn(
                    size: ResponsiveUtils.width(context, isTablet ? 18 : 20),
                    assetPath: 'assets/svgs/home_btn.svg',
                    onPressed: () {
                      context.go(RoutePaths.home);
                    },
                  ),
                  IconElevatedBtn(
                    size: ResponsiveUtils.width(context, isTablet ? 18 : 24),
                    assetPath: 'assets/svgs/replay_btn.svg',
                    onPressed: () {
                      context.pop(0);
                    },
                  ),
                  if (currentIndex < (homeCardList.length - 1))
                    IconElevatedBtn(
                      size: ResponsiveUtils.width(context, isTablet ? 18 : 20),
                      assetPath: 'assets/svgs/next_btn.svg',
                      onPressed: () {
                        context.pop();
                        context.push(
                          RoutePaths.detail,
                          extra: {
                            'category': homeCardList[currentIndex + 1].category,
                            'index': currentIndex + 1,
                          },
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
