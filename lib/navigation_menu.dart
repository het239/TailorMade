import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailormade/features/personalization/screens/settings/settings.dart';
import 'package:tailormade/features/shop/screens/cart/cart.dart';
import 'package:tailormade/features/shop/screens/home/home.dart';
import 'package:tailormade/features/shop/screens/shop/store.dart';
import 'package:tailormade/utils/constants/colors.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/tailor_controller.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunction.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
          controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withAlpha(25)
              : TColors.black.withAlpha(25),
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.explore_outlined), label: 'Explore'),
            NavigationDestination(
                icon: Icon(Iconsax.shopping_cart), label: 'Cart'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const CartScreen(),
    const SettingsScreen()
  ];
}