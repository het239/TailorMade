import 'package:flutter/material.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

import '../../../utils/constants/colors.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key,
    required this.dividerText
  });

  final String dividerText;


  @override
  Widget build(BuildContext context) {
    final dark =  THelperFunction.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Divider(
                color: dark ? TColors.darkGrey : TColors.greay,
                thickness: 0.5,
                indent: 60,
                endIndent: 5)),
        Text(dividerText,
            style: Theme.of(context).textTheme.labelMedium),
        Flexible(
            child: Divider(
                color: dark ? TColors.darkGrey : TColors.greay,
                thickness: 0.5,
                indent: 5,
                endIndent: 60)),
      ],
    );
  }
}

