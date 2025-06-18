import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/common/widgets/appbar/appbar.dart';
import 'package:tailormade/features/shop/screens/tailor_reviews/widgets/rating_progress_indicator.dart';
import 'package:tailormade/features/shop/screens/tailor_reviews/widgets/user_review_card.dart';
import '../../../../common/widgets/products/rating/rating_indicator.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/shop/controllers/feedbackController.dart';

class TailorReviewScreen extends StatelessWidget {
  final String tailorId;

  const TailorReviewScreen({super.key, required this.tailorId});

  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController = Get.find<FeedbackController>();

    // Fetch feedback for the specific tailor
    feedbackController.fetchFeedbackForTailor(tailorId);

    return Scaffold(
      /// Appbar
      appBar: TAppBar(title: const Text('Reviews'), showBackArrow: true),

      /// Body
      body: Obx(() {
        if (feedbackController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (feedbackController.tailorFeedbackList.isEmpty) {
          return const Center(
            child: Text("No reviews available."),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Ratings and reviews are verified and are from people who use the same type of device that you use."),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Overall Product Ratings
                TOverallTailorRating(tailorId: tailorId),
                TRatingBarIndicator(rating: feedbackController.averageRating),
                Text(
                  '${feedbackController.totalReviews} Reviews',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// User Reviews List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: feedbackController.tailorFeedbackList.length,
                  itemBuilder: (_, index) {
                    final feedback = feedbackController.tailorFeedbackList[index];
                    return UserReviewCard(
                      userName: feedback['user_name'] ?? "Anonymous",
                      rating: feedback['rating'] ?? 0,
                      comments: feedback['comments'] ?? '',
                      createdAt: feedback['created_at'] ?? '',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}