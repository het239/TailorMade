import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/features/personalization/screens/Measurement/book_appointment/book_appointment.dart';
import 'package:tailormade/features/personalization/screens/Measurement/self_measured/self_measured.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';

class TGetMeasured extends StatelessWidget {
  const TGetMeasured({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final SessionController sessionController = Get.find();

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Get Measured',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Display selected style
              Text(
                'Selected Style: ${sessionController.selectedStyle}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Self Measured Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sessionController.setMeasurementType('SelfMeasured');
                    Get.to(() => TTailorSelfMeasured());
                  },
                  child: const Text('Self Measured'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark ? TColors.darkerGrey : TColors.black,
                    padding: const EdgeInsets.all(TSizes.lg),
                    side: BorderSide(
                      color: dark ? TColors.darkerGrey : TColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 110), // Adjusted spacing

              /// Home Visit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sessionController.setMeasurementType('HomeVisit');
                    Get.to(() => TTailorBookAppointment());
                  },
                  child: const Text('Home Visit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark ? TColors.darkerGrey : TColors.black,
                    padding: const EdgeInsets.all(TSizes.lg),
                    side: BorderSide(
                      color: dark ? TColors.darkerGrey : TColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}