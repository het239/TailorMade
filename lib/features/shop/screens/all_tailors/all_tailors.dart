import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../common/widgets/products/tailor_card/tailor_card_vertical.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/tailor_controller.dart';

class AllTailors extends StatelessWidget {
  const AllTailors({super.key});

  @override
  Widget build(BuildContext context) {
    final tailorController = Get.put(TailorController());

    void handleSearch(String query) {
      // Implement your search logic here
      tailorController.searchTailors(query);
    }

    return Scaffold(
      appBar: const TAppBar(title: Text('Popular Tailor'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Search Bar with Filter Icon
              TSearchContainer(
                text: 'Search',
                onSearch: handleSearch,
                // showFilterIcon: true, // Enabling filter icon in the search bar
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Products
              Obx(
                    () {
                  if (tailorController.tailors.isEmpty) {
                    return const Center(
                      child: Text('No tailors are available', style: TextStyle(fontSize: 18)),
                    );
                  } else {
                    return TGridLayout(
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
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}