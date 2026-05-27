import 'package:eflash_multilagnuage_upgrade/core/utils/helper.dart';
import 'package:eflash_multilagnuage_upgrade/database/db_provider.dart';
import 'package:eflash_multilagnuage_upgrade/router/route_paths.dart';
import 'package:eflash_multilagnuage_upgrade/services/music_services.dart';
import 'package:eflash_multilagnuage_upgrade/widgets/app_background.dart';
import 'package:eflash_multilagnuage_upgrade/widgets/ask_language.dart';
import 'package:eflash_multilagnuage_upgrade/widgets/home_cards.dart';
import 'package:eflash_multilagnuage_upgrade/widgets/topbar.dart';
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

                        if (!isJapanese)
                          HomeCards(
                            imagePath: "assets/images/alphabets.png",
                            title: "The Alphabets",
                            subText: AppHelpers.getCount(
                              "Alphabet",
                              state.categoryCounts,
                            ),
                            cardBg: Color(0xffe5cb5b),
                            onPress: () => context.push(
                              state.questionMode == true
                                  ? RoutePaths.exercise
                                  : RoutePaths.detail,
                              extra: 'Alphabet',
                            ),
                          ),
                        HomeCards(
                          imagePath: "assets/images/animals.png",
                          title: "Animals",
                          subText: AppHelpers.getCount(
                            "Animal",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xffb6c0fd),
                          btnBg: Color(0xff468fde),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'Animal',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/numbers.png",
                          title: "Numbers",
                          // subText: "Total 26 Charter",
                          subText: AppHelpers.getCount(
                            "Numbers",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xfff27650),
                          btnBg: Color(0xfff6d138),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'Numbers',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/body_parts.png",
                          title: "Body parts",
                          subText: AppHelpers.getCount(
                            "BodyParts",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xffed052d),
                          btnBg: Color(0xff7ac88e),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'BodyParts',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/music_instu.png",
                          title: "Music Instuments",
                          subText: AppHelpers.getCount(
                            "ArtMusic",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xffe6606c),
                          btnBg: Color(0xffb16e37),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'ArtMusic',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/colors.png",
                          title: "Colors",
                          subText: AppHelpers.getCount(
                            "Colors",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xff7ac88e),
                          btnBg: Color(0xffe6606c),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'Colors',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/shaps.png",
                          title: "Shaps",
                          subText: AppHelpers.getCount(
                            "Shapes",
                            state.categoryCounts,
                          ),
                          // cardBg: Color(0xff48adce),
                          cardBg: Color(0xffecea00),
                          btnBg: Color(0xffe7a700),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'Shapes',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/fruts.png",
                          title: "Fruts & Food",
                          subText: AppHelpers.getCount(
                            "Food",
                            state.categoryCounts,
                          ),
                          // cardBg: Color(0xff48adce),
                          cardBg: Color(0xff4f97fe),
                          btnBg: Color(0xffed052d),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'Food',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/vehicles.png",
                          title: "Vehicles",
                          subText: AppHelpers.getCount(
                            "Transport",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xfff27650),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'Transport',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/sports.png",
                          title: "Sports & Things",
                          subText: AppHelpers.getCount(
                            "OutdoorItems",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xffe5cb5b),
                          btnBg: Color(0xff7ac88e),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'OutdoorItems',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/cloths.png",
                          title: "Cloths",
                          subText: AppHelpers.getCount(
                            "Clothing",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xfff27650),
                          btnBg: Color(0xfff6d138),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'Clothing',
                          ),
                        ),
                        HomeCards(
                          imagePath: "assets/images/home_applainses.png",
                          title: "Random Things",
                          subText: AppHelpers.getCount(
                            "HomeItems",
                            state.categoryCounts,
                          ),
                          cardBg: Color(0xffb6c0fd),
                          btnBg: Color(0xff468fde),
                          onPress: () => context.push(
                            state.questionMode == true
                                ? RoutePaths.exercise
                                : RoutePaths.detail,
                            extra: 'HomeItems',
                          ),
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
