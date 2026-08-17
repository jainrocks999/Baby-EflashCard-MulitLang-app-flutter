import 'package:baby_flash_apps/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final RequestConfiguration requestConfiguration = RequestConfiguration(
    ageRestrictedTreatment: AgeRestrictedTreatment.child,
    maxAdContentRating: MaxAdContentRating.g,
  );

  await MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  await MobileAds.instance.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Baby Flash Apps',
      routerConfig: appRouter,
    );
  }
}
