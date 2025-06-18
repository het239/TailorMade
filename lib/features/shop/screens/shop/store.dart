import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/common/widgets/appbar/appbar.dart';
import 'package:tailormade/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:tailormade/common/widgets/layout/grid_layout.dart';
import 'package:tailormade/common/widgets/texts/section_heading.dart';
import 'package:tailormade/features/shop/controllers/feedbackController.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/products/tailor_card/t_brand_card.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../home/widgets/promo_slider.dart';
import '../tailor_reviews/widgets/user_review_card.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final feedbackController = Get.put(FeedbackController());

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: TAppBar(
          title: Text('Explore',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunction.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                expandedHeight: 340,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: TSizes.spaceBtwSections),
                      TPromoSlider(
                        banners: [
                          TImages.promobanner1,
                          TImages.promobanner2,
                          TImages.promobanner3
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                /// Popular Tailors Section
                TSectionHeading(
                  title: 'Tailors Feedbacks',
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Overall Rating Summary
                // Obx(() {
                //   if (feedbackController.isLoading.value) {
                //     return const Center(child: CircularProgressIndicator());
                //   }
                //
                //   if (feedbackController.feedbackList.isEmpty) {
                //     return const Center(child: Text("No feedbacks available."));
                //   }

                  // return Column(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Text(
                  //           "${feedbackController.averageRating.toStringAsFixed(1)}",
                  //           style: Theme.of(context).textTheme.displayLarge,
                  //         ),
                  //         const SizedBox(width: TSizes.spaceBtwItems),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Average Rating",
                  //               style: Theme.of(context).textTheme.bodyMedium,
                  //             ),
                  //             Text(
                  //               "Based on ${feedbackController.totalReviews} reviews",
                  //               style: Theme.of(context).textTheme.labelMedium,
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(height: TSizes.spaceBtwSections),
                  //   ],
                  // );
                // }),

                /// Feedback List
                Expanded(
                  child: Obx(() {
                    if (feedbackController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (feedbackController.allFeedbackList.isEmpty) {
                      return const Center(child: Text("No feedbacks available."));
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await feedbackController.fetchAllFeedback();
                      },
                      child: ListView.builder(
                        itemCount: feedbackController.allFeedbackList.length,
                        itemBuilder: (_, index) {
                          final feedback = feedbackController.allFeedbackList[index];
                          return UserReviewCard(
                            userName: feedback['user_name'] ?? "Anonymous",
                            rating: feedback['rating'] ?? 0,
                            comments: feedback['comments'] ?? '',
                            createdAt: feedback['created_at'] ?? '',
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}