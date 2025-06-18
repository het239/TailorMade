import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/common/widgets/appbar/appbar.dart';
import 'package:tailormade/common/widgets/images/t_circular_image.dart';
import 'package:tailormade/common/widgets/texts/section_heading.dart';
import 'package:tailormade/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:tailormade/features/personalization/screens/profile/widgets/update_profle.dart';
import 'package:tailormade/utils/constants/image_strings.dart';
import 'package:tailormade/utils/constants/sizes.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';
import '../../../authentication/screens/login/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final SupabaseClient supabase = Supabase.instance.client;

    Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
      return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ?? false;
    }

    Future<void> _deleteAccount() async {
      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not found");
        return;
      }

      bool confirmDelete = await _showDeleteConfirmationDialog(context);
      if (!confirmDelete) return;

      try {
        // Delete user record from 'users' table
        await supabase.from('users').delete().eq('user_id', user.id);

        // Delete user from authentication
        await supabase.auth.admin.deleteUser(user.id);

        // Sign out and redirect to login
        await supabase.auth.signOut();
        Get.offAll(() => const LoginScreen());
      } catch (e) {
        Get.snackbar("Error", "Failed to delete account: $e");
      }
    }

    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const TCircularImage(image: TImages.usesr, width: 80, height: 80),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TProfileMenu(
                title: 'First Name',
                value: userController.firstName.value,
                onPressed: () {},
                //   => Get.to(() => UpdateProfileFieldScreen(
                //   title: 'First Name',
                //   field: 'first_name',
                //   initialValue: userController.firstName.value,
                // )),
              )),
              Obx(() => TProfileMenu(
                title: 'Last Name',
                value: userController.lastName.value,
                onPressed: () => {},
                // Get.to(() => UpdateProfileFieldScreen(
                //   title: 'Last Name',
                //   field: 'last_name',
                //   initialValue: userController.lastName.value,
                // )),
              )),
              Obx(() => TProfileMenu(
                title: 'Phone Number',
                value: userController.phone.value,
                onPressed: () {},
                //   => Get.to(() => UpdateProfileFieldScreen(
                //   title: 'Phone Number',
                //   field: 'phone',
                //   initialValue: userController.phone.value,
                // )),
              )),
              Obx(() => TProfileMenu(
                title: 'E-Mail',
                value: userController.email.value,
                onPressed: () {},
                showArrow: false,
              )),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                  onPressed: _deleteAccount,
                  child: const Text("Close Account", style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}