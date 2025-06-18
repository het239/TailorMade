import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/common/widgets/success_screen/success_screen.dart';

import '../login/login.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String userEmail;
  const EmailVerificationScreen({super.key, required this.userEmail});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final supabase = Supabase.instance.client;
  late Timer _timer;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await Future.delayed(const Duration(seconds: 1)); // Allow session update
      await checkEmailVerification();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerification() async {
    try {
      final currentUser = supabase.auth.currentUser; // Get the current user directly
      if (currentUser == null) {
        debugPrint("⚠ No active user, skipping email verification check.");
        return;
      }

      // Check if the user's email is verified
      if (currentUser.emailConfirmedAt != null) {
        setState(() => _isVerified = true);
        _timer.cancel();

        // Navigate to the success screen
        Get.offAll(() => SuccessScreen(
          image: "assets/images/animations/staticSuccess.png",
          title: "You can now log in.",
          subTitle: " ",
          onPressed: () => Get.offAll(() => const LoginScreen()),
        ));
      } else {
        debugPrint("❌ Email is NOT verified yet.");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<void> resendVerificationEmail() async {
    await supabase.auth.signInWithOtp(email: widget.userEmail);
    Get.snackbar("Success", "A new verification email has been sent!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.message, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text("We've sent a verification email to:", textAlign: TextAlign.center),
              const SizedBox(height: 5),
              Text(widget.userEmail, style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
              const SizedBox(height: 20),
              const Text("Please check your inbox and click the link to verify your email."),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: OutlinedButton(
                  onPressed: resendVerificationEmail,
                  child: const Text('Resend'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}