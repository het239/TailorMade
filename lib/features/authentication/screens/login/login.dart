
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/common/styles/spacing_styles.dart';
import 'package:tailormade/features/authentication/screens/login/widgets/login_form.dart';
import 'package:tailormade/features/authentication/screens/login/widgets/login_header.dart';
import 'package:tailormade/utils/constants/sizes.dart';
import 'package:tailormade/utils/constants/text_strings.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWthAppBarHeight,
          child: Column(
            children: [
              /// Logo,Title & sub_title
              const TLoginHeader(),

              /// Form
              const TLoginForm(),

              /// Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox( height: TSizes.spaceBtwSections),

              /// Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
