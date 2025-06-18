import 'package:flutter/material.dart';
import 'package:tailormade/utils/constants/enumns.dart';

class TTailorTitleText extends StatelessWidget {
  const TTailorTitleText({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.color,
    this.tailorTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final Color? color;
  final TextSizes tailorTextSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: tailorTextSize == TextSizes.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
          : tailorTextSize == TextSizes.medium
              ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
              : tailorTextSize == TextSizes.large
                  ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
                  : Theme.of(context).textTheme.bodyMedium!.apply(color: color),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
