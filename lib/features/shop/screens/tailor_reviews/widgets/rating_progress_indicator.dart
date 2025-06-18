import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/features/shop/controllers/feedbackController.dart';
import 'package:tailormade/features/shop/screens/tailor_reviews/widgets/progress_indicator_and_ratinig.dart';

class TOverallTailorRating extends StatelessWidget {
  final String tailorId;

  const TOverallTailorRating({
    super.key,
    required this.tailorId,
  });

  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController = Get.find<FeedbackController>();

    // Group ratings and calculate counts for each rating (1 to 5)
    final Map<int, int> ratingCounts = {};
    for (int i = 1; i <= 5; i++) {
      ratingCounts[i] = feedbackController.tailorFeedbackList
          .where((feedback) => feedback['rating'] == i)
          .length;
    }

    // Total reviews
    final int totalReviews = feedbackController.totalReviews;

    // Calculate average rating
    final double averageRating = feedbackController.averageRating;

    return Obx(() {
      if (feedbackController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (totalReviews == 0) {
        return const Center(
          child: Text("No ratings available."),
        );
      }

      return Row(
        children: [
          // Average Rating
          Expanded(
            flex: 3,
            child: Text(
              averageRating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          // Rating Distribution
          Expanded(
            flex: 7,
            child: Column(
              children: [
                for (int i = 5; i >= 1; i--)
                  TRatingProgressIndicator(
                    text: i.toString(),
                    value: totalReviews > 0
                        ? (ratingCounts[i]! / totalReviews)
                        : 0.0,
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}