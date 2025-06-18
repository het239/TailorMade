import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Page controller for onboarding
  final PageController pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// Update current index when scrolling
  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  /// Jump to specific page when dot navigation is clicked
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  /// Navigate to the next page or finish onboarding
  Future<void> nextPage() async {
    if (currentPageIndex.value == 2) {
      await _completeOnboarding();
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  /// Skip to the last onboarding page
  Future<void> skipPage() async {
    currentPageIndex.value = 2;
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    await _completeOnboarding();
  }

  /// Save onboarding completion and navigate to login
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    Get.offAll(() => const LoginScreen());
  }
}
