import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';
import 'package:tailormade/utils/constants/sizes.dart';

class UpdateProfileFieldScreen extends StatelessWidget {
  final String title;
  final String field;
  final String initialValue;
  final TextEditingController controller = TextEditingController();

  UpdateProfileFieldScreen({
    super.key,
    required this.title,
    required this.field,
    required this.initialValue,
  }) {
    controller.text = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final SupabaseClient supabase = Supabase.instance.client;

    Future<void> _updateProfileField() async {
      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not found");
        return;
      }

      try {
        var updatedValue = controller.text;
        Map<String, dynamic> updatedData = {field: updatedValue};

        // Log user id and updated data for debugging
        print('User ID: ${user.id}');
        print('Updated Data: $updatedData');

        final response = await supabase
            .from('users')
            .update(updatedData)
            .eq('user_id', user.id)
            .select();

        // Log the full response for debugging
        print('Update response: $response');

        if (response == null || response.isEmpty) {
          throw 'Update failed';
        }

        // Update GetX controller with the new value
        if (field == 'first_name') userController.firstName.value = updatedValue;
        if (field == 'last_name') userController.lastName.value = updatedValue;
        if (field == 'phone') userController.phone.value = updatedValue;

        Get.snackbar("Success", "Profile updated successfully");
      } catch (e) {
        Get.snackbar("Error", "Failed to update profile: $e");
        print("Error: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update $title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: title),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateProfileField,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}