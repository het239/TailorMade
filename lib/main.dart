import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'config.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/tailor_controller.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';
import 'package:tailormade/features/shop/controllers/service_controller.dart';
import 'package:tailormade/features/shop/controllers/feedbackController.dart';
import 'features/authentication/screens/password_configuration/reset_password.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(autoRefreshToken: true),
    );

    // ✅ Restore session
    final session = Supabase.instance.client.auth.currentSession;
    debugPrint(session == null ? "⚠ No active session found." : "✅ Session restored: ${session.user.email}");

    // ✅ Register UserController in GetX (Ensure only one instance)
    Get.put(UserController());
    Get.put(TailorController());
    Get.put(TailorServiceController());
    Get.put(SessionController());
    Get.put(FeedbackController());


    // ✅ Check if onboarding is completed
    final prefs = await SharedPreferences.getInstance();
    final bool hasCompletedOnboarding = prefs.getBool('onboardingCompleted') ?? false;
    debugPrint('🟢 Onboarding Completed: $hasCompletedOnboarding');


    // ✅ Handle Deep Link for Password Reset
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.passwordRecovery) {
        debugPrint("🔗 Password Recovery Deep Link Triggered");
        Get.to(() => const ResetPassword());
      }
    });


    // ✅ Run the app
    runApp(App(hasCompletedOnboarding: hasCompletedOnboarding));

  } catch (e, stackTrace) {
    debugPrint('🚨 Supabase Initialization Error: $e');
    debugPrint(stackTrace.toString());

    // ✅ Run app with safe fallback
    runApp(App(hasCompletedOnboarding: false));
  }
}