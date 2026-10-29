import 'package:flutter/material.dart';
import '../features/splash/screens/splash_screen.dart';
import 'theme/app_theme.dart';

class CarbonTrackApp extends StatelessWidget {
  final Widget? home;

  const CarbonTrackApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code2Carbon',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: home ?? const SplashScreen(),
    );
  }
}
