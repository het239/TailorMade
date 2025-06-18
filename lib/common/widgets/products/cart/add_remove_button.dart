import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';

class TProductQuntityWithAddRemoveButton extends StatelessWidget {
  final VoidCallback increment;
  final VoidCallback decrement;
  final int quantity;

  const TProductQuntityWithAddRemoveButton({
    super.key,
    required this.increment,
    required this.decrement,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: THelperFunction.isDarkMode(context) ? TColors.darkerGrey : TColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: decrement,
            child: const Icon(Iconsax.minus, size: 18, color: TColors.primary),
          ),
          const SizedBox(width: 6),
          Text(
            quantity.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: increment,
            child: const Icon(Iconsax.add, size: 18, color: TColors.primary),
          ),
        ],
      ),
    );
  }
}