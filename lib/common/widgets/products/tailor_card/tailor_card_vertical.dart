  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:tailormade/common/styles/shadows.dart';
  import 'package:tailormade/common/widgets/custom_shapes/containers/rounded_container.dart';
  import 'package:tailormade/common/widgets/images/t_rounded_image.dart';
  import 'package:tailormade/features/shop/screens/tailor_detail/tailor_detail.dart';
  import 'package:tailormade/utils/constants/enumns.dart';
  import 'package:tailormade/utils/helpers/helper_functions.dart';

  import '../../../../utils/constants/colors.dart';
  import '../../../../utils/constants/image_strings.dart';
  import '../../../../utils/constants/sizes.dart';
  import '../../texts/t_tailor_title_with_verified_icon.dart';
  import 'package:tailormade/features/shop/controllers/feedbackController.dart';


  class TProductCardHorizontal extends StatelessWidget {
    final String tailorId;
    final String shopName;

    const TProductCardHorizontal({
      super.key,
      required this.tailorId,
      required this.shopName,
    });

    @override
    Widget build(BuildContext context) {
      final dark = THelperFunction.isDarkMode(context);
      final feedbackController = Get.put(FeedbackController());


      return GestureDetector(
        onTap: () => Get.to(() => TailorDetail(tailorId: tailorId)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(TSizes.sm),
          decoration: BoxDecoration(
            boxShadow: [TShadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: dark ? TColors.darkGrey : TColors.white,
          ),
          child: Row(
            children: [
              /// Column with Image and Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Thumbnail Image
                  TRoundedContainer(
                    height: 50,
                    width: 70,
                    padding: const EdgeInsets.all(TSizes.sm),
                    backgroundColor: dark ? TColors.dark : TColors.greay,
                    child: TRoundedImage(
                      imageUrl: TImages.profil,
                      applyImageRadius: true,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),

                  /// Rating Container
                  // In your TProductCardHorizontal widget:
                  Obx(() {
                    final avgRating = feedbackController.getAverageRatingForTailor(tailorId);

                    return TRoundedContainer(
                      radius: TSizes.md,
                      backgroundColor: TColors.white.withAlpha((0.8 * 255).toInt()),
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm, vertical: TSizes.xs),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: TColors.secondary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            avgRating.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: TColors.black),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              /// Product Details and View Button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: TSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TTailorTitleWithVerifiedIcon(title: shopName, tailorTextSize: TextSizes.medium),
                      const SizedBox(height: TSizes.spaceBtwItems / 2),
                      Text('Customize your wardrobe with $shopName',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }