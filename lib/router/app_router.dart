import 'package:baby_flash_apps/router/route_paths.dart';
import 'package:baby_flash_apps/screens/detail/playground_screen.dart';
import 'package:baby_flash_apps/screens/exercise/exercise_screen.dart';
import 'package:baby_flash_apps/screens/home/home_screen.dart';
import 'package:baby_flash_apps/screens/setting/settings_screen.dart';
import 'package:baby_flash_apps/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.detail,
      builder: (context, state) {
        final category = state.extra as String;
        return PlaygroundScreen(category: category);
      },
    ),
    GoRoute(
      path: RoutePaths.exercise,
      builder: (context, state) {
        final category = state.extra as String;
        return ExerciseScreen(category: category);
      },
    ),
    GoRoute(
      path: RoutePaths.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
