import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailormade/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:tailormade/utils/constants/colors.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import '../../../../../utils/constants/sizes.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.selectedAddress,
    required this.name,
    required this.phone,
    required this.address,
  });

  final bool selectedAddress;
  final String name;
  final String phone;
  final String address;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return TRoundedContainer(
      width: double.infinity,
      showBorder: true,
      backgroundColor: selectedAddress
          ? TColors.primaryNew.withAlpha((0.5 * 255).toInt())
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : dark
          ? TColors.darkerGrey
          : TColors.greay,
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color: selectedAddress
                  ? dark
                  ? TColors.light
                  : TColors.dark
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: TSizes.sm / 2),
                Text(phone, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: TSizes.sm / 2),
                Text(address, softWrap: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
