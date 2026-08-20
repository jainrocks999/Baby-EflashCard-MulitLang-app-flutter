import 'package:baby_flash_apps/ads/banner_ad.dart';
import 'package:baby_flash_apps/core/utils/responsive.dart';
import 'package:baby_flash_apps/database/db_provider.dart';
import 'package:baby_flash_apps/services/music_services.dart';
import 'package:baby_flash_apps/widgets/app_background.dart';
import 'package:baby_flash_apps/widgets/ask_language.dart';
import 'package:baby_flash_apps/widgets/home_card_basiclist.dart';
import 'package:baby_flash_apps/widgets/home_card_gridlist.dart';
import 'package:baby_flash_apps/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        final bool isTablet = ResponsiveUtils.isTablet(context);
        return Scaffold(
          body: AppBackground(
            child: Stack(
              children: [
                Column(
                  children: [
                    const TopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                        child: Column(
                          spacing: 20,
                          children: [
                            SizedBox(
                              child: Image.asset(
                                "assets/images/app_name.png",
                                width: ResponsiveUtils.widthPercent(
                                  context,
                                  isTablet ? 40 : 65,
                                ),
                              ),
                            ),
                            isTablet
                                ? HomeCardGridlist(isJapanese: isJapanese)
                                : HomeCardBasiclist(isJapanese: isJapanese),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(child: const BannerAdSection()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
