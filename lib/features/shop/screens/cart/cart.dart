import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/features/shop/screens/cart/widgets/cart_item.dart';
import 'package:tailormade/features/shop/screens/checkout/checkout.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/tailor_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = Get.find();
    final TailorController tailorController = Get.find();
    sessionController.loadSession();

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Obx(() {
          if (sessionController.cartItems.isEmpty) {
            print("Cart is empty");
            return Center(child: Text('Your cart is empty.'));
          }
          print("Cart has items: ${sessionController.cartItems.length}");
          return TCartItems(sessionController: sessionController);
        }),
      ),
      bottomNavigationBar: Obx(() {
        if (sessionController.cartItems.isEmpty) {
          return SizedBox.shrink();
        }

        final totalPrice = sessionController.cartItems.fold(0.0, (sum, item) {
          return sum + item.price * item.quantity;
        });

        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ElevatedButton(
            onPressed: totalPrice > 0 ? () => Get.to(() => const CheckoutScreen()) : null,
            child: Text('Checkout ₹${totalPrice.toStringAsFixed(2)}'),
          ),
        );
      }),
    );
  }
}