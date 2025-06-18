import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/features/shop/screens/getmeasured/get_measured.dart';
import 'package:tailormade/features/shop/screens/style/widgets/clothing_card.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/image_strings.dart';
import 'package:tailormade/features/shop/controllers/service_controller.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';

class TTailorStyle extends StatelessWidget {
  final String tailorId;

  const TTailorStyle({super.key, required this.tailorId});

  @override
  Widget build(BuildContext context) {
    final TailorServiceController serviceController = Get.put(TailorServiceController());
    final SessionController sessionController = Get.find<SessionController>();
    serviceController.fetchServices(tailorId);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Choose Your Style',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Obx(() {
        if (serviceController.services.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select the type of clothing you want to create:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// GridView for Clothing Options
                TGridLayout(
                  itemCount: serviceController.services.length,
                  mainAxisExtent: 200, // Adjust the extent as needed
                  itemBuilder: (context, index) {
                    final service = serviceController.services[index];
                    return GestureDetector(
                      onTap: () {
                        sessionController.setSelectedStyle(service.serviceName);
                        Get.to(() => TGetMeasured());
                      },
                      child: ClothingCard(
                        clothingType: service.serviceName,
                        imagePath: TImages.getImageForService(service.serviceName),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}