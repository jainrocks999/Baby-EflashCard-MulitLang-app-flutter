import 'package:baby_flash_apps/core/constants/app_colors.dart';
import 'package:baby_flash_apps/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class HomeCards extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subText;
  final Color? btnBg;
  final Color cardBg;
  final VoidCallback onPress;

  const HomeCards({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subText,
    required this.cardBg,
    required this.onPress,
    this.btnBg,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.width(context, isTablet ? 2 : 3)),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Image.asset(
              imagePath,
              height: ResponsiveUtils.height(context, isTablet ? 25 : 15),
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "BubblegumSans",
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            isTablet ? 8 : 7,
                          ),
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryTxt,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        subText,
                        style: TextStyle(
                          fontFamily: "BubblegumSans",
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            isTablet ? 3.5 : 4.5,
                          ),
                          color: AppColors.primaryTxt,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  child: ElevatedButton(
                    onPressed: onPress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnBg,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.width(context, isTablet ? 10 : 8),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryTxt,
                      size: ResponsiveUtils.width(context, isTablet ? 7 : 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
