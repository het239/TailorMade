import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/common/widgets/appbar/appbar.dart';
import 'package:tailormade/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tailormade/common/widgets/list_tile/seettings_menu_tile.dart';
import 'package:tailormade/common/widgets/list_tile/user_profile_tile.dart';
import 'package:tailormade/common/widgets/texts/section_heading.dart';
import 'package:tailormade/features/personalization/screens/Measurement/measurement_history/measurement_history.dart';
import 'package:tailormade/features/personalization/screens/address/address.dart';
import 'package:tailormade/features/personalization/screens/profile/profile.dart';
import 'package:tailormade/features/shop/screens/cart/cart.dart';
import 'package:tailormade/features/shop/screens/order/order.dart';
import 'package:tailormade/utils/constants/colors.dart';
import 'package:tailormade/utils/constants/sizes.dart';

import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';
import '../../../authentication/screens/login/login.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>(); // Get user details

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                  ),

                  /// User Profile Card
                  TUserProfileTile(
                    firstName: userController.firstName.value,
                    lastName: userController.lastName.value,
                    email: userController.email.value,
                    onPressed: () => Get.to(() => const ProfileScreen()),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Account Settings
                  TSectionHeading(title: 'Account Settings', showActionButton: false),
                  SizedBox(height: TSizes.spaceBtwItems),

                  /// User Addresses
                  TSettingMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'My Addresses',
                    subTitle: 'Set Shopping delivery address',
                    onTap: () => Get.to(() => const UserAddressScreen()),
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'My Cart',
                    subTitle: 'Add, remove products and move to checkout',
                    onTap: () => Get.to(() => const CartScreen()),
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'My Orders',
                    subTitle: 'In-progress and Complete Orders',
                    onTap: () => Get.to(() => const OrderScreen()),
                  ),
                  // TSettingMenuTile(
                  //   icon: Iconsax.rulerpen,
                  //   title: 'My Measurement History',
                  //   subTitle: 'Records of Past and Present Measurements',
                  //   onTap: () => Get.to(() => const TMeasurementHistory()),
                  // ),

                  /// Logout Button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();
                        Get.offAll(() => const LoginScreen());
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
