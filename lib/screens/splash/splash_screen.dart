import 'package:eflash_multilagnuage_upgrade/database/db_provider.dart';
import 'package:eflash_multilagnuage_upgrade/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initLang();

    _controller = VideoPlayerController.asset('assets/videos/splash(1).mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        if (mounted) {
          context.go(RoutePaths.home);
        }
      }
    });
  }

  Future<void> _initLang() async {
    await ref.read(dbProvider.notifier).loadLanguage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          // fit: BoxFit.contain,
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
