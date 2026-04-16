import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'ui/splash/splash_screen.dart';
import 'ui/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shiksha',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(nextScreen: HomeScreen()),
    );
  }
}
