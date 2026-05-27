import 'package:eflash_multilagnuage_upgrade/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HomeCards extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subText;
  final Color btnBg;
  final Color cardBg;
  final VoidCallback onPress;

  const HomeCards({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subText,
    required this.cardBg,
    required this.onPress,
    this.btnBg = AppColors.primaryBtnBg,
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
            child: Image.asset(imagePath, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: "BubblegumSans",
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryTxt,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      subText,
                      style: TextStyle(
                        fontFamily: "BubblegumSans",
                        fontSize: 15,
                        color: AppColors.primaryTxt,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  child: ElevatedButton(
                    onPressed: onPress,
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.green,
                      backgroundColor: btnBg,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryTxt,
                      size: 35,
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
