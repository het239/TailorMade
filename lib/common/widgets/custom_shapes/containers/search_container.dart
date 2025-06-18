import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key,
    required this.text,
    this.onTap,
    this.onSearch,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
    this.showFilterIcon = false,
  });

  final String text;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSearch;
  final EdgeInsetsGeometry padding;
  final bool showFilterIcon;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: Border.all(color: TColors.greay),
            color: THelperFunction.isDarkMode(context) ? TColors.dark : TColors.textWhite,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: text,
                    hintStyle: TextStyle(
                      color: THelperFunction.isDarkMode(context) ? TColors.white : TColors.dark,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: THelperFunction.isDarkMode(context) ? TColors.white : TColors.dark),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: THelperFunction.isDarkMode(context) ? TColors.white : TColors.dark,
                    fontSize: 14,
                  ),
                  onChanged: (value) {
                    if (onSearch != null) {
                      onSearch!(value);
                    }
                  },
                ),
              ),
              if (showFilterIcon)
                IconButton(
                  icon: Icon(Iconsax.filter, color: THelperFunction.isDarkMode(context) ? TColors.white : TColors.dark),
                  onPressed: () {
                    // Implement filter logic here
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
