import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/products/rating/rating_indicator.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class UserReviewCard extends StatelessWidget {
  final String userName;
  final double rating; // Ensure this is a double
  final String comments;
  final String createdAt;

  const UserReviewCard({
    super.key,
    required this.userName,
    required this.rating,
    required this.comments,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(backgroundImage: AssetImage(TImages.usesr)),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(userName, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        /// Review
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TRatingBarIndicator(rating: rating), // Ensure rating is double
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(createdAt, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Comments
        ReadMoreText(
          comments,
          trimLines: 1,
          trimMode: TrimMode.Line,
          trimExpandedText: ' show less',
          trimCollapsedText: ' show more',
          moreStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TColors.primary),
          lessStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TColors.primary),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
      ],
    );
  }
}