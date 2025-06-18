import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailormade/common/widgets/texts/tailor_title_text.dart';
import 'package:tailormade/utils/constants/enumns.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TTailorTitleWithVerifiedIcon extends StatelessWidget {
  const TTailorTitleWithVerifiedIcon({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.textColor,
    this.iconColor = TColors.primary,
    this.textAlign = TextAlign.center,
    this.tailorTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes tailorTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TTailorTitleText(
            title: title,
            maxLines: maxLines,
            color : textColor,
            textAlign: textAlign,
            tailorTextSize: tailorTextSize,
          ),
        ),
        const SizedBox(width: TSizes.xs),
        Icon(Iconsax.verify5, color: iconColor, size: TSizes.iconXs),
      ],
    );
  }
}
