import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailormade/common/widgets/success_screen/success_screen.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';
import 'package:tailormade/features/shop/models/cartmodel.dart';
import 'package:tailormade/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:tailormade/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:tailormade/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:tailormade/navigation_menu.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final SessionController sessionController = Get.find();

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -- Items in Cart (Simplified Display with Images)
              _SimplifiedCartItemsWithImages(sessionController: sessionController),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Billing Section
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Column(
                  children: [
                    /// Pricing
                    TBillingAmountSection(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Divider
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Payment Methods
                    TBillingPaymentSection(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Address
                    TBillingAddressSection(),
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// Checkout Button
      bottomNavigationBar: Obx(() {
        final totalPrice = sessionController.cartItems.fold(0.0, (sum, item) {
          return sum + item.price * item.quantity;
        });

        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ElevatedButton(
            onPressed: totalPrice > 0
                ? () => Get.to(
                  () => SuccessScreen(
                image: TImages.successfullPayment,
                title: 'Payment Success.!',
                subTitle: 'Your item will be shipped soon!',
                onPressed: () => Get.offAll(() => const NavigationMenu()),
              ),
            )
                : null,
            child: Text('Checkout ₹${totalPrice.toStringAsFixed(2)}'),
          ),
        );
      }),
    );
  }
}

class _SimplifiedCartItemsWithImages extends StatelessWidget {
  final SessionController sessionController;

  const _SimplifiedCartItemsWithImages({
    required this.sessionController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (sessionController.cartItems.isEmpty) {
        return Center(child: Text('Your cart is empty.'));
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessionController.cartItems.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final CartItemModel item = sessionController.cartItems[index];
          return _SimplifiedCartItemWithImage(item: item);
        },
      );
    });
  }
}

class _SimplifiedCartItemWithImage extends StatelessWidget {
  final CartItemModel item;

  const _SimplifiedCartItemWithImage({required this.item});

  @override
  Widget build(BuildContext context) {
    // Fetch the image URL or fallback to a default asset image
    String imageUrl = TImages.getImageForService(item.style);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
      child: Row(
        children: [
          /// Item Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: imageUrl.startsWith('http') // Check if the URL is a network URL
                  ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
                  : DecorationImage(
                image: AssetImage(imageUrl), // Use AssetImage for local images
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),

          /// Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.style,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          /// Item Price
          Text(
            '₹${(item.price.value * item.quantity).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}