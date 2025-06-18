import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/features/authentication/screens/role/user_role.dart';
import 'package:tailormade/navigation_menu.dart'; // Customer screen
import '../../../../../Tailor/Navigation_tailor/navigation_menu_tailor.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';
import '../../password_configuration/forget_password.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';


class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  _TLoginFormState createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        Get.snackbar("Error", "Invalid email or password.", snackPosition: SnackPosition.BOTTOM);
        setState(() => _isLoading = false);
        return;
      }

      // Fetch user details
      final userData = await supabase
          .from('users')
          .select('user_id, first_name, last_name, email, phone, role_id, role:role_id(role_name)')
          .eq('user_id', user.id)
          .maybeSingle();

      if (userData == null || userData['role'] == null || userData['role']['role_name'] == null) {
        Get.snackbar("Error", "User role not found.", snackPosition: SnackPosition.BOTTOM);
        setState(() => _isLoading = false);
        return;
      }

      // Store user data in GetX controller
      final userController = Get.put(UserController());
      userController.setUser(
        userId: userData['user_id'],
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        email: userData['email'],
        phone: userData['phone'],
      );

      // Set user ID in SessionController
      final sessionController = Get.put(SessionController());
      sessionController.setUserId(userData['user_id']); // Set the user ID for session management

      final roleName = userData['role']['role_name'].toString().toLowerCase();

      // Navigate based on role
      if (roleName == "customer") {
        Get.offAll(() => NavigationMenu());
      } else if (roleName == "tailor") {
        Get.offAll(() => NavigationMenuTailor());
      } else {
        Get.snackbar("Error", "Unauthorized access.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Login Failed", "Error: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "Email cannot be empty.";
                if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(value)) {
                  return "Enter a valid email address.";
                }
                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "Password cannot be empty.";
                if (value.length < 6) return "Password must be at least 6 characters.";
                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value!),
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(TTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginUser,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(TTexts.signIN),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const UserRole()),
                child: const Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}