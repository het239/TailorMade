import 'package:flutter/material.dart';
import 'package:tailormade/common/widgets/texts/t_tailor_title_with_verified_icon.dart';
import 'package:tailormade/common/widgets/texts/tailor_title_text.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/enumns.dart';
import '../../../../../utils/constants/sizes.dart';

class TTailorMetaData extends StatelessWidget {
  final String tailorName;
  final bool isAvailable;

  const TTailorMetaData({
    super.key,
    required this.tailorName,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final darkmode = THelperFunction.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        TTailorTitleWithVerifiedIcon(title: tailorName, tailorTextSize: TextSizes.medium),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        /// Stock
        Row(
          children: [
            const TTailorTitleText(title: 'Status'),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(isAvailable ? 'Available' : 'Unavailable', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),
      ],
    );
  }
}