import 'package:baby_flash_apps/core/constants/app_colors.dart';
import 'package:baby_flash_apps/core/constants/category.dart';
import 'package:baby_flash_apps/core/utils/helper.dart';
import 'package:baby_flash_apps/database/db_provider.dart';
import 'package:baby_flash_apps/router/route_paths.dart';
import 'package:baby_flash_apps/widgets/home_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeCardBasiclist extends ConsumerWidget {
  final bool isJapanese;

  const HomeCardBasiclist({super.key, required this.isJapanese});

  void handleOnPress({
    required BuildContext context,
    required dynamic item,
    required int index,
    required bool questionMode,
  }) {
    final route = questionMode ? RoutePaths.exercise : RoutePaths.detail;

    context.push(route, extra: {'category': item.category, 'index': index});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dbProvider);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeCardList.length,
      itemBuilder: (context, index) {
        final item = homeCardList[index];

        if (isJapanese && item.category == 'Alphabet') {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: HomeCards(
            imagePath: item.imagePath,
            title: item.title,
            subText: AppHelpers.getCount(item.category, state.categoryCounts),
            cardBg: item.cardBg,
            btnBg: item.btnBg ?? AppColors.primaryBtnBg,
            onPress: () => handleOnPress(
              context: context,
              item: item,
              index: index,
              questionMode: state.questionMode,
            ),
          ),
        );
      },
    );
  }
}
