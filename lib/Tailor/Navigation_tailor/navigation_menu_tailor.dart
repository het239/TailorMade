import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailormade/Tailor/Home/tailor_home.dart';
import 'package:tailormade/Tailor/report/tailor_report.dart';
import 'package:tailormade/Tailor/settings/Tsettings.dart';
import 'package:tailormade/utils/constants/colors.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

class NavigationMenuTailor extends StatelessWidget {
  const NavigationMenuTailor({super.key});

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
            NavigationDestination(icon: Icon(Icons.shopping_bag), label: 'Orders'),
            NavigationDestination(icon: Icon(Icons.insert_chart), label: 'Reports'),
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
    const TailorHomeScreen(),
    const TailorReportScreen(),
    const TSettingsScreen()
  ];
}