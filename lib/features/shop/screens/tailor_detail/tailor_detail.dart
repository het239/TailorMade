import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailormade/common/widgets/texts/section_heading.dart';
import 'package:tailormade/features/shop/screens/style/tailor_style.dart';
import 'package:tailormade/features/shop/screens/tailor_detail/widgets/tailor_attribute.dart';
import 'package:tailormade/features/shop/screens/tailor_detail/widgets/tailor_meta_data.dart';
import 'package:tailormade/features/shop/screens/tailor_reviews/tailor_reviews.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import '../../../../utils/constants/colors.dart';
import '../../../authentication/controllers.onboarding/tailor_controller.dart';
import 'widgets/rating_widget.dart';
import 'widgets/tailor_detail_menu_slider.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';
import 'package:tailormade/features/shop/controllers/feedbackController.dart';


class TailorDetail extends StatelessWidget {
  final String tailorId;

  const TailorDetail({super.key, required this.tailorId});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight = MediaQuery.of(context).size.height; // Get screen height

    final TailorController tailorController = Get.find();
    final FeedbackController feedbackController = Get.put(FeedbackController());
    final SessionController sessionController = Get.find();

    // Fetch tailor details and feedback for this tailor
    tailorController.fetchTailorDetails(tailorId);
    feedbackController.fetchFeedbackForTailor(tailorId);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Tailor Image Slider
            SizedBox(
              height: screenHeight * 0.25, // Adjust based on screen height
              child: TTailorImageSlider(tailorId: tailorId),
            ),

            /// Tailor Detail Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // 5% of screen width
                vertical: screenHeight * 0.02, // 2% of screen height
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Rating & Share Button
                  TRating(tailorId: tailorId),
                  SizedBox(height: screenHeight * 0.01), // Spacing

                  /// Title & Shop Details
                  Obx(() {
                    if (tailorController.tailorDetails.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return TTailorMetaData(
                        tailorName: tailorController.tailorDetails['shop_name'],
                        isAvailable: tailorController.tailorDetails['available'] ?? false,
                      );
                    }
                  }),
                  SizedBox(height: screenHeight * 0.02),

                  /// Tailor Attributes (Services, Pricing, etc.)
                  TTailorAttribute(),
                  SizedBox(height: screenHeight * 0.03),

                  /// Order Button (Responsive)
                  Obx(() {
                    bool isAvailable = tailorController.tailorDetails['available'] ?? false;
                    if (!isAvailable) {
                      return SizedBox.shrink(); // Return an empty widget
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06, // Adjust button height
                      child: ElevatedButton(
                        onPressed: () {
                          sessionController.setSelectedShopName(tailorController.tailorDetails['shop_name']);
                          Get.to(() => TTailorStyle(tailorId: tailorId));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.black,
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          side: const BorderSide(color: TColors.black),
                        ),
                        child: const Text('Order For Stitching'),
                      ),
                    );
                  }),
                  SizedBox(height: screenHeight * 0.03),

                  /// Reviews Section
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final reviewCount = feedbackController.tailorFeedbackList.length;
                        return TSectionHeading(
                          title: 'Reviews($reviewCount)',
                          showActionButton: false,
                        );
                      }),
                      IconButton(
                        onPressed: () => Get.to(() => TailorReviewScreen(tailorId: tailorId)),
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}