import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/features/authentication/screens/singnup/widgets/tems_condition_checkbox.dart';
import '../email_verification.dart';

class TSignupForm extends StatefulWidget {
  final String roleId;
  const TSignupForm({super.key, required this.roleId});

  @override
  _TSignupFormState createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isChecked = false;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate() || !isChecked) return;

    try {
      // Sign up the user
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        emailRedirectTo: 'io.supabase.flutter://email-verification',
      );

      final userId = response.user?.id;
      if (userId == null) {
        throw AuthException('Signup failed. Please check your email for verification.');
      }

      // Insert user details into the 'users' table
      await supabase.from('users').insert({
        'user_id': userId,
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role_id': widget.roleId.trim(),
      });

      // Navigate to the email verification screen
      Get.to(() => EmailVerificationScreen(userEmail: emailController.text.trim()));
    } catch (e) {
      // Handle errors and display appropriate messages
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: "First Name", prefixIcon: Icon(Iconsax.user)),
                  validator: (value) => value!.length < 2 ? "Must be at least 2 characters" : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: "Last Name", prefixIcon: Icon(Iconsax.user)),
                  validator: (value) => value!.length < 2 ? "Must be at least 2 characters" : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Iconsax.direct)),
            validator: (value) => !GetUtils.isEmail(value!) ? "Enter a valid email" : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Phone", prefixIcon: Icon(Iconsax.call)),
            validator: (value) => value!.length != 10 ? "Enter a valid 10-digit phone number" : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash),
                onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
              ),
            ),
            validator: (value) => value!.length < 8 ? "Must be at least 8 characters" : null,
          ),
          const SizedBox(height: 10),
          TTermsAndConditionCheckbox(onChanged: (value) => setState(() => isChecked = value)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isChecked ? registerUser : null,
              child: const Text("Create Account"),
            ),
          ),
        ],
      ),
    );
  }
}