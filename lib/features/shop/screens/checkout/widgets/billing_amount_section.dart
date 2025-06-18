import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = Get.find();

    return Obx(() {
      // Calculate the subtotal
      final double subtotal = sessionController.cartItems.fold(0.0, (sum, item) {
        return sum + (item.price.value * item.quantity);
      });

      // Define static values for shipping and tax fees
      const double shippingFee = 6.0;
      const double taxFee = 6.0;

      // Calculate order total
      final double orderTotal = subtotal + shippingFee + taxFee;

      return Column(
        children: [
          /// SubTotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${subtotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          /// Shipping Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${shippingFee.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          /// Tax Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${taxFee.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          /// Order Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${orderTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      );
    });
  }
}