import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/shop/controllers/feedbackController.dart';

class TRating extends StatelessWidget {
  final String tailorId;

  const TRating({
    super.key,
    required this.tailorId,
  });

  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController = Get.find<FeedbackController>();

    return Obx(() {
      final double averageRating = feedbackController.averageRating;
      final int totalReviews = feedbackController.totalReviews;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Rating
          Row(
            children: [
              const Icon(Iconsax.star5, color: Colors.amber, size: 24),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: averageRating.toStringAsFixed(1), // Display average rating
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text: ' ($totalReviews)', // Display total reviews
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ])),
            ],
          ),
        ],
      );
    });
  }
}