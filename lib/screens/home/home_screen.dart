import 'package:baby_flash_apps/core/constants/app_colors.dart';
import 'package:baby_flash_apps/core/constants/category.dart';
import 'package:baby_flash_apps/core/utils/helper.dart';
import 'package:baby_flash_apps/database/db_provider.dart';
import 'package:baby_flash_apps/router/route_paths.dart';
import 'package:baby_flash_apps/services/music_services.dart';
import 'package:baby_flash_apps/widgets/app_background.dart';
import 'package:baby_flash_apps/widgets/ask_language.dart';
import 'package:baby_flash_apps/widgets/home_cards.dart';
import 'package:baby_flash_apps/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isModalShown = false;

  void _openLanguageModal(String? language) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return LanguageSelectionModal(
          selectedLanguage: language ?? 'tbl_items',
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(dbProvider.notifier).loadCateCounts();
      await ref.read(dbProvider.notifier).loadQuestionMode();
      await ref.read(dbProvider.notifier).loadSoundAndLangSettings();
      if (!mounted) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(dbProvider);
        ref.listen(dbProvider, (prev, next) {
          if (prev?.isMusicOn == next.isMusicOn) {
            return;
          }

          if (next.isMusicOn) {
            MusicService().playMusic();
          } else {
            MusicService().stopMusic();
          }
        });

        final isJapanese = state.language?.contains('japanies') ?? false;
        if (state.language == null && !_isModalShown) {
          _isModalShown = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _openLanguageModal(state.language);
          });
        }

        return Scaffold(
          body: AppBackground(
            child: Column(
              children: [
                const TopBar(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                    child: Column(
                      spacing: 20,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          child: Image.asset(
                            "assets/images/app_name.png",
                            width: double.infinity,
                          ),
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeCardList.length,
                          itemBuilder: (context, index) {
                            final item = homeCardList[index];
                            if (isJapanese && item.category == 'Alphabet') {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsetsGeometry.only(bottom: 20),
                              child: HomeCards(
                                imagePath: item.imagePath,
                                title: item.title,
                                subText: AppHelpers.getCount(
                                  item.category,
                                  state.categoryCounts,
                                ),
                                cardBg: item.cardBg,
                                btnBg: item.btnBg ?? AppColors.primaryBtnBg,
                                onPress: () => context.push(
                                  state.questionMode == true
                                      ? RoutePaths.exercise
                                      : RoutePaths.detail,
                                  extra: {
                                    'category':item.category,
                                    'index':index
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
