import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/features/shop/screens/all_tailors/all_tailors.dart';
import 'package:tailormade/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:tailormade/features/shop/screens/home/widgets/promo_slider.dart';
import '../../../../common/widgets/appbar/appbar_home.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../common/widgets/products/tailor_card/tailor_card_vertical.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/tailor_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tailorController = Get.put(TailorController());

    void handleSearch(String query) {
      tailorController.searchTailors(query);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Search Bar
                  TSearchContainer(
                    text: 'Search',
                    onSearch: handleSearch,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// HomeBar Logo
                  Appbar_row(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Promo Slider
                  TPromoSlider(
                    banners: [
                      TImages.promobanner1,
                      TImages.promobanner2,
                      TImages.promobanner3
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  TSectionHeading(
                    title: 'Popular Tailors',
                    onPressed: () => Get.to(() => const AllTailors()),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// Popular Tailor
                  Obx(() {
                    print("Tailors length: ${tailorController.tailors.length}");
                    return tailorController.tailors.isEmpty
                        ? const Center(
                      child: Text(
                        'No tailors are available',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                        : TGridLayout(
                      itemCount: tailorController.tailors.length,
                      crossAxisCount: 1,
                      itemBuilder: (_, index) {
                        final tailor = tailorController.tailors[index];
                        return TProductCardHorizontal(
                          tailorId: tailor['tailor_id'],
                          shopName: tailor['shop_name'],
                        );
                      },
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}