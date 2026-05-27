import 'package:eflash_multilagnuage_upgrade/core/utils/helper.dart';
import 'package:eflash_multilagnuage_upgrade/router/route_paths.dart';
import 'package:eflash_multilagnuage_upgrade/widgets/icon_elevated_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).path;
    final isDetail =  (current?.contains(RoutePaths.detail) ?? false) ||
    (current?.contains(RoutePaths.exercise) ?? false);

    return AppBar(
      toolbarHeight: 75,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: showBackButton ? 85 : null,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 15),
              child: IconElevatedBtn(
                assetPath: 'assets/svgs/back_btn.svg',
                onPressed: () {
                  Navigator.of(context).maybePop();
                },

                elevation: 0,
              ),
            )
          : null,
      actions: [
        if (!isDetail)
          IconElevatedBtn(
            assetPath: 'assets/svgs/setting_btn.svg',
            onPressed: () {
              AppHelpers.showSettingModal(context);
            },
            elevation: 0,
          ),
        const SizedBox(width: 15),
      ],
    );
  }
}
