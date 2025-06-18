import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../features/authentication/controllers.onboarding/user_controller.dart';

class TProfileScreen extends StatelessWidget {
  const TProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final userController = Get.find<UserController>();

    final TextEditingController shopNameController = TextEditingController(text: userController.shopName.value);
    final TextEditingController descriptionController = TextEditingController(text: userController.description.value);
    RxBool isAvailable = userController.isAvailable;

    Future<void> saveProfile() async {
      try {
        if (userController.tailorId.value.isEmpty) {
          // Insert new tailor record
          final response = await userController.supabase
              .from('tailor')
              .insert({
            'user_id': userController.userId.value,
            'shop_name': shopNameController.text,
            'available': isAvailable.value,
            'description': descriptionController.text,
          })
              .select()
              .single();

          userController.tailorId.value = response['tailor_id'];
        } else {
          // Update existing tailor record
          await userController.supabase
              .from('tailor')
              .update({
            'shop_name': shopNameController.text,
            'available': isAvailable.value,
            'description': descriptionController.text,
          })
              .eq('user_id', userController.userId.value);
        }

        // Update local state
        userController.shopName.value = shopNameController.text;
        userController.description.value = descriptionController.text;
        userController.isAvailable.value = isAvailable.value;
        userController.isTailor.value = true;

        Get.back();
        Get.snackbar("Success", "Profile updated successfully.", snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar("Error", "Failed to update profile: $e", snackPosition: SnackPosition.BOTTOM);
      }
    }

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Edit Details',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: shopNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.shop),
                  labelText: 'Shop Name',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.info_circle),
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available For Stitching',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: isAvailable.value,
                    onChanged: (value) {
                      isAvailable.value = value;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveProfile,
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark ? TColors.darkerGrey : TColors.black,
                    padding: const EdgeInsets.all(TSizes.md),
                    side: BorderSide(
                      color: dark ? TColors.darkerGrey : TColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}