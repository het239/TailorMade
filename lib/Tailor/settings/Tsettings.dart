import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/Tailor/settings/TServices.dart';
import 'package:tailormade/Tailor/settings/Tuser_profile_tile.dart';
import 'package:tailormade/Tailor/settings/updateScreen.dart';
import 'package:tailormade/Tailor/settings/updatedAddress.dart';
import 'package:tailormade/common/widgets/appbar/appbar.dart';
import 'package:tailormade/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tailormade/common/widgets/list_tile/seettings_menu_tile.dart';
import 'package:tailormade/common/widgets/texts/section_heading.dart';
import 'package:tailormade/features/authentication/screens/login/login.dart';
import 'package:tailormade/features/personalization/screens/address/add_new_address.dart';
import 'package:tailormade/features/shop/screens/order/order.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'Tprofile.dart';

class TSettingsScreen extends StatefulWidget {
  const TSettingsScreen({super.key});

  @override
  State<TSettingsScreen> createState() => _TSettingsScreenState();
}

class _TSettingsScreenState extends State<TSettingsScreen> {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            TPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Obx(() => TUserProfileTile(
                    onPressed: () => Get.to(() => const TProfileScreen()),
                    shopName: userController.shopName.value,
                    isAvailable: userController.isAvailable.value,
                  )),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Shop Address Heading
                  TSectionHeading(
                      title: 'Shop Address', showActionButton: false),
                  SizedBox(height: TSizes.spaceBtwItems),

                  /// Conditionally show "Add Shop Addresses" or list of addresses
                  Obx(() {
                    if (userController.addresses.isEmpty) {
                      return TSettingMenuTile(
                        icon: Iconsax.safe_home,
                        title: 'Add Shop Addresses',
                        subTitle: 'Set Shop address for Orders',
                        onTap: () => Get.to(() => const AddNewAddressScreen()),
                      );
                    } else {
                      return Column(
                        children: userController.addresses.map((address) {
                          return ListTile(
                            title: Text(address['address_type']),
                            subtitle: Text('${address['street']}, ${address['city']}, ${address['state']}, ${address['postal_code']}'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () => Get.to(() => UpdateAddressScreen(address: address)),
                          );
                        }).toList(),
                      );
                    }
                  }),

                  /// Services Heading
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                      title: 'Services', showActionButton: false),
                  SizedBox(height: TSizes.spaceBtwItems),

                  /// Conditionally show "Add Services" or list of services
                  Obx(() {
                    if (userController.services.isEmpty) {
                      return TSettingMenuTile(
                        icon: Iconsax.safe_home,
                        title: 'Add Services',
                        subTitle: 'Set Services that you want to Deliver',
                        onTap: () => Get.to(() => const TailorServiceScreen()),
                      );
                    } else {
                      return Column(
                        children: [
                          ...userController.services.map((service) {
                            return ListTile(
                              title: Text(service['service_name']),
                              subtitle: Text('Price: ${service['price']}'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // Navigate to UpdateServicePriceScreen for updating the price
                                Get.to(() => UpdateServicePriceScreen(service: service));
                              },
                            );
                          }).toList(),
                          const SizedBox(height: TSizes.spaceBtwSections * 2),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () => Get.to(() => const TailorServiceScreen()),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text(
                                'Add More',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),

                  TSettingMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'My Orders',
                    subTitle: 'In-progress and Complete Orders',
                    onTap: () => Get.to(() => const OrderScreen()),
                  ),

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