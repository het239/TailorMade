import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../authentication/controllers.onboarding/tailor_controller.dart';

class TTailorImageSlider extends StatefulWidget {
  final String tailorId;

  const TTailorImageSlider({
    super.key,
    required this.tailorId,
  });

  @override
  _TTailorImageSliderState createState() => _TTailorImageSliderState();
}

class _TTailorImageSliderState extends State<TTailorImageSlider> {
  final TailorController tailorController = Get.find();
  List<String> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final response = await tailorController.supabase
          .from('tailorservices')
          .select('service_name')
          .eq('tailor_id', widget.tailorId)
          .order('service_name', ascending: true);

      if (response != null) {
        setState(() {
          services = (response as List).map((item) => item['service_name'] as String).toList();
        });
      } else {
        // Handle error if needed
        print('Error fetching services');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return TCurvedEdgeWidget(
      child: Container(
        color: dark ? TColors.darkGrey : TColors.greay,
        child: Stack(
          children: [
            /// Main Large Image
            const SizedBox(
              height: 250,
              child: Padding(
                padding: EdgeInsets.all(TSizes.productImageRadius * 4),
                // child: Center(
                //     child: Image(
                //         image: AssetImage(TImages.tailorshop3))),
              ),
            ),

            /// Service Images Slider or No Services Message
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 90,
                child: services.isEmpty
                    ? Center(
                  child: Text(
                    'No services added by the tailor.',
                    style: TextStyle(
                      color: dark ? TColors.white : TColors.black,
                      fontSize: 16,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: services.length,
                  shrinkWrap: false,  // ✅ Ensure it takes full space and allows scrolling
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),  // ✅ Smoother scrolling experience
                  itemBuilder: (_, index) {
                    final service = services[index];
                    final imageUrl = TImages.getImageForService(service);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),  // ✅ Add spacing between items
                      child: TRoundedImage(
                        width: 90,
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        border: Border.all(color: TColors.primary),
                        padding: const EdgeInsets.all(TSizes.sm),
                        imageUrl: imageUrl,
                      ),
                    );
                  },
                ),
              ),
            ),

            /// Appbar Icons
            const TAppBar(
              showBackArrow: true,
            )
          ],
        ),
      ),
    );
  }
}