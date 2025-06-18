import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TSignupHeader extends StatelessWidget {
  const TSignupHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Image(
      height: 150,
      image: AssetImage(
          dark ? TImages.darkAppLogo : TImages.lightAppLogo),
    );
  }
}

