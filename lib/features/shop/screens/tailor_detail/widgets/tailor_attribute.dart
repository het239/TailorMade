import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:tailormade/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:tailormade/common/widgets/texts/section_heading.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/tailor_controller.dart';

class TTailorAttribute extends StatelessWidget {
  const TTailorAttribute({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final TailorController tailorController = Get.find();

    return Column(
      children: [
        /// Selected Attribute
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.md),
          backgroundColor: dark ? TColors.darkerGrey : TColors.greay,
          child: Column(
            children: [
              Row(
                children: [
                  const TSectionHeading(
                      title: 'Description', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Obx(() {
                if (tailorController.tailorDetails.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ReadMoreText(
                    tailorController.tailorDetails['description'] ?? 'No description available.',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show More',
                    trimExpandedText: 'Less',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  );
                }
              }),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Location Section
        Obx(() {
          if (tailorController.tailorDetails.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: dark ? TColors.white : TColors.black, size: 20),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: Text(
                          tailorController.tailorDetails['address'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  children: [
                    Icon(Icons.phone,
                        color: dark ? TColors.white : TColors.black, size: 20),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: Text(
                          tailorController.tailorDetails['phone'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ],
            );
          }
        }),
      ],
    );
  }
}