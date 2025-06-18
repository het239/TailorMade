import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository(this.supabase);

  /// ✅ Sign up user using Supabase Auth
  Future<String?> signUpUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      return response.user?.id; // Return User ID
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Signup failed: ${e.toString()}");
    }
  }

  /// ✅ Insert user data into the `users` table (without storing password)
  Future<void> insertUserData({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String roleId,
  }) async {
    try {
      await supabase.from('users').insert({
        'user_id': userId,
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'role_id': roleId.trim(),
      });
    } catch (e) {
      throw Exception("User data insertion failed: ${e.toString()}");
    }
  }
}
