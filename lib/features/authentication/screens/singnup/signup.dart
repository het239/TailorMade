import 'package:flutter/material.dart';
import 'package:tailormade/features/authentication/screens/singnup/widgets/signup_form.dart';
import 'package:tailormade/features/authentication/screens/singnup/widgets/signup_header.dart';
import 'package:tailormade/utils/constants/text_strings.dart';
import '../../../../utils/constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  final String roleId;
  const SignupScreen({super.key, required this.roleId});

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
              Text(TTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              TSignupForm(roleId: roleId),
            ],
          ),
        ),
      ),
    );
  }
}
