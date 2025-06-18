import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/features/authentication/screens/onboarding/onboarding.dart';
import 'package:tailormade/utils/theme/theme.dart';

import 'features/authentication/screens/login/login.dart';

class App extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const App({super.key, required this.hasCompletedOnboarding});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: hasCompletedOnboarding ? const LoginScreen() : const OnBoardingScreen(),
    );
  }
}
