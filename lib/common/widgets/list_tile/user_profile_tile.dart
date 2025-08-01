import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/t_circular_image.dart';

class TUserProfileTile extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final VoidCallback onPressed;

  const TUserProfileTile({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const TCircularImage(image: TImages.usesr, width: 50, height: 50, padding: 0),
      title: Text(
        '$firstName $lastName',
        style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),
      ),
      subtitle: Text(
        email,
        style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(Iconsax.edit, color: TColors.white),
      ),
    );
  }
}
