import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/tailor_controller.dart';
import '../../../../../common/widgets/Price/Tailor_Price_Text.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/sizes.dart';
import 'cart_item.dart';

class TCartItems extends StatelessWidget {
  final SessionController sessionController;
  final bool showAddRemoveButtons;

  const TCartItems({
    super.key,
    required this.sessionController,
    this.showAddRemoveButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    final TailorController tailorController = Get.find();

    return ListView.separated(
      shrinkWrap: true,
      itemCount: sessionController.cartItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwSections),
      itemBuilder: (_, index) {
        final item = sessionController.cartItems[index];
        // Fetch the price for the selected style and tailor ID
        tailorController.fetchServicePrice(item);
        return TCartItem(
          item: item,
          sessionController: sessionController,
        );
      },
    );
  }
}