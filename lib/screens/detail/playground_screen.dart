import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:baby_flash_apps/core/utils/helper.dart';
import 'package:baby_flash_apps/core/utils/responsive.dart';
import 'package:baby_flash_apps/database/db_provider.dart';
import 'package:baby_flash_apps/services/music_services.dart';
import 'package:baby_flash_apps/widgets/app_background.dart';
import 'package:baby_flash_apps/widgets/custom_snackbar.dart';
import 'package:baby_flash_apps/widgets/icon_elevated_btn.dart';
import 'package:baby_flash_apps/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaygroundScreen extends ConsumerStatefulWidget {
  final String category;
  const PlaygroundScreen({super.key, required this.category});

  @override
  ConsumerState<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends ConsumerState<PlaygroundScreen> {
  final GlobalKey<ImageSliderState> sliderKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(dbProvider.notifier).fetchData(category: widget.category);
      await ref.read(dbProvider.notifier).loadSoundAndLangSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dbProvider);
    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
   final bool isTablet = ResponsiveUtils.isTablet(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(dbProvider.notifier).clearData();
        }
      },
      child: Scaffold(
        body: AppBackground(
          child: Column(
            children: [
              const TopBar(showBackButton: true),
              SizedBox(height: ResponsiveUtils.height(context, isTablet ? 1 : 1),),
              ImageSlider(
                key: sliderKey,
                data: state.data,
                isShowLangTxt: state.isShowLangTxt,
                isSoundOn: state.isSoundOn,
                isSwpieOn: state.isSwpieOn,
              ),
              Spacer(),
              Row(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconElevatedBtn(
                    size: ResponsiveUtils.width(
                        context,
                        isTablet ? 10 : 20,
                      ),
                    assetPath: 'assets/svgs/left_btn.svg',
                    onPressed: () {
                      sliderKey.currentState?.previousPage();
                    },
                  ),
                  IconElevatedBtn(
                    assetPath: 'assets/svgs/replay_btn.svg',
                    onPressed: () {
                      if (state.isSoundOn) {
                        final stateRef = sliderKey.currentState;
                        if (stateRef != null) {
                          stateRef.playItemAudio(
                            stateRef.widget.data[stateRef.currentIndex],
                          );
                        }
                      } else {
                        showCustomSnackBar(
                          context: context,
                          title: "Sound is Off",
                          subtitle:
                              " Turn on sound in settings to hear the fun sounds 🎵",
                          backgroundColor: Color(0xffb3903e),
                          icon: Icons.volume_off,
                        );
                      }
                    },
                    // size: 120,
                    size: ResponsiveUtils.width(
                        context,
                        isTablet ? 10 : 28,
                      ),
                  ),
                  IconElevatedBtn(
                    size: ResponsiveUtils.width(
                        context,
                        isTablet ? 10 : 20,
                      ),
                    assetPath: 'assets/svgs/right_btn.svg',
                    onPressed: () {
                      sliderKey.currentState?.nextPage();
                    },
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageSlider extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final bool isShowLangTxt;
  final bool isSoundOn;
  final bool isSwpieOn;
  const ImageSlider({
    super.key,
    required this.data,
    required this.isShowLangTxt,
    required this.isSoundOn,
    required this.isSwpieOn,
  });

  @override
  State<ImageSlider> createState() => ImageSliderState();
}

class ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final StreamSubscription<PlayerState> _playerStateSub;

  int currentIndex = 0;
  bool isPlaying = false;

  Future<void>? _currentTask;

  @override
  void initState() {
    super.initState();
    _configureAudioPlayer();
    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      if (state == PlayerState.playing) {
        setState(() => isPlaying = true);
      } else if (state == PlayerState.completed ||
          state == PlayerState.stopped ||
          state == PlayerState.paused) {
        setState(() => isPlaying = false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.data.isNotEmpty) {
        if (widget.isSoundOn) {
          playItemAudio(widget.data[0]);
        }
      }
    });
  }

  Future<void> _configureAudioPlayer() async {
    try {
      await _audioPlayer.setAudioContext(MusicService.effectsAudioContext);
    } catch (e) {
      debugPrint("Playground audio context error: $e");
    }
  }

  @override
  void didUpdateWidget(covariant ImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _audioPlayer.stop();
      // _audioPlayer.release();

      setState(() {
        currentIndex = 0;
      });

      if (widget.data.isNotEmpty) {
        if (widget.isSoundOn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playItemAudio(widget.data[0]);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _playerStateSub.cancel();
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> playItemAudio(Map<String, dynamic> item) async {
    _currentTask = _playInternal(item);
    await _currentTask;
  }

  Future<void> _playInternal(Map<String, dynamic> item) async {
    await MusicService().runWithDuckedMusic(() async {
      try {
        await _audioPlayer.stop();
        // await _audioPlayer.release();

        final langName = AppHelpers.getLanguageFolder(item['language_name']);

        // final actualSound = item['actualsound'];
        final actualSound = langName == 'japanies'
            ? item['actualsound']?.replaceAll('-', '_')
            : item['actualsound'];
        final sound = langName == 'english'
            ? item['sound']
            : item['sound']?.replaceAll(' ', '_');

        if (actualSound != null &&
            actualSound.toString().isNotEmpty &&
            actualSound.toString() != '0') {
          await _audioPlayer.play(AssetSource('files/$langName/$actualSound'));

          try {
            await _audioPlayer.onPlayerComplete.first.timeout(
              const Duration(seconds: 8),
            );
          } catch (_) {}
        }

        if (!mounted) return;

        if (sound != null && sound.toString().isNotEmpty) {
          await _audioPlayer.play(AssetSource('files/$langName/$sound'));
          try {
            await _audioPlayer.onPlayerComplete.first.timeout(
              const Duration(seconds: 8),
            );
          } catch (_) {}
        }
      } catch (e) {
        debugPrint("Audio error: $e");
      }
    });
  }

  void nextPage() {
    if (currentIndex < widget.data.length - 1) {
      _controller.animateToPage(
        currentIndex + 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      _controller.animateToPage(
        currentIndex - 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);
    return Column(
      spacing: ResponsiveUtils.height(context, isTablet ? 2 : 4),
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.width(context, isTablet ? 3 : 5.5),
            vertical: ResponsiveUtils.height(context, isTablet ? 1 : 1.5),
          ),
          decoration: BoxDecoration(
            color: Colors.amber[200],
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, isTablet ? 2 : 4)),
            border: Border.all(width: 2, color: Colors.amber),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${currentIndex + 1}/${widget.data.length}',
            style: TextStyle(
              color: Colors.black54,
              // fontSize: 20,
              fontSize: ResponsiveUtils.fontSize(context, isTablet ? 5 : 5.5),
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        // SizedBox(height: 20),
        widget.isShowLangTxt
            ? Container(
                // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.width(context, isTablet ? 3 : 5.5),
            vertical: ResponsiveUtils.height(context, isTablet ? 1 : 1.5),
          ),
                decoration: BoxDecoration(
                  color: Color(0xffb3eafd),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, isTablet ? 2 : 4)),
                  border: Border.all(
                    width: 2,
                    color: Colors.white.withAlpha(150),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: widget.data.isNotEmpty
                    ? Text(
                        '${widget.data[currentIndex]['word'] ?? widget.data[currentIndex]['sound'].replaceAll('.mp3', '')}?',
                        style: TextStyle(
                          color: Colors.black54,
                          // fontSize: 16,
                          fontSize: ResponsiveUtils.fontSize(context, isTablet ? 3 : 4.5),
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              )
            : SizedBox(height: 57),

        SizedBox(
          // height: 350,
          height: ResponsiveUtils.height(context, isTablet ? 40 : 40),
          width: ResponsiveUtils.width(context, isTablet ? 40 : 88),
          child: GestureDetector(
            onHorizontalDragStart: (_) {
              if (!widget.isSwpieOn) {
                showCustomSnackBar(
                  context: context,
                  title: "Swipe Disabled",
                  subtitle: "Turn on swipe from settings to move images",
                  backgroundColor: Color(0xffb3903e),
                  icon: Icons.swipe,
                );
              }
            },
            child: AbsorbPointer(
              absorbing: !widget.isSwpieOn,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.data.length,
                physics: widget.isSwpieOn
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                  final item = widget.data[index];
                  if (widget.isSoundOn) {
                    playItemAudio(item);
                  }
                },
                itemBuilder: (context, index) {
                  String itemImg = widget.data[index]["image"];

                  if (widget.data[index]['category'] == 'Alphabet') {
                    itemImg = AppHelpers.getModifiedImgName(
                      image: widget.data[index]["image"],
                      langName: widget.data[index]["language_name"],
                    );
                  }
                  if (widget.data[index]['category'] == 'Numbers' &&
                      AppHelpers.getLanguageFolder(
                            widget.data[index]["language_name"],
                          ) ==
                          'japanies') {
                    itemImg = AppHelpers.getModifiedImgName(
                      image: widget.data[index]["image"],
                      langName: widget.data[index]["language_name"],
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/files/$itemImg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
