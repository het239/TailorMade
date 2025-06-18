import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/features/authentication/screens/singnup/signup.dart';
import 'package:tailormade/features/authentication/screens/singnup/widgets/signup_header.dart';
import 'package:tailormade/utils/constants/text_strings.dart';
import '../../../../utils/constants/sizes.dart';

class UserRole extends StatefulWidget {
  const UserRole({super.key});

  @override
  _UserRoleState createState() => _UserRoleState();
}

class _UserRoleState extends State<UserRole> {
  final supabase = Supabase.instance.client;
  Map<String, String> roleIds = {};

  @override
  void initState() {
    super.initState();
    fetchRoles();
  }

  /// Fetch role IDs from Supabase
  Future<void> fetchRoles() async {
    final response = await supabase.from('role').select('role_id, role_name');
    if (response.isNotEmpty) {
      setState(() {
        for (var role in response) {
          roleIds[role['role_name']] = role['role_id'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              const TSignupHeader(),

              /// Title
              Text(TTexts.roleTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 50),

              /// Customer Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (roleIds.containsKey('Customer')) {
                      Get.to(() => SignupScreen(roleId: roleIds['Customer']!));
                    }
                  },
                  child: const Text(TTexts.customer),
                ),
              ),
              const SizedBox(height: 100),

              /// Tailor Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (roleIds.containsKey('Tailor')) {
                      Get.to(() => SignupScreen(roleId: roleIds['Tailor']!));
                    }
                  },
                  child: const Text(TTexts.tailor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
