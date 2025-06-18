import 'package:flutter/material.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';


class ClothingCard extends StatelessWidget {
  final String clothingType;
  final String imagePath;

  const ClothingCard({
    Key? key,
    required this.clothingType,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.light : TColors.greay,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(177), // Replaced with withAlpha method
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Clothing Image
          Image.asset(
            imagePath,
            height: 120,
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Clothing Name
          Text(
            clothingType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
