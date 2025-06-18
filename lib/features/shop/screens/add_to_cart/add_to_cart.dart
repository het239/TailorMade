import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:tailormade/navigation_menu.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';

import '../../models/cartmodel.dart';

class TAddToCart extends StatefulWidget {
  final String shopName;
  final String style;

  const TAddToCart({
    super.key,
    required this.shopName,
    required this.style,
  });

  @override
  State<TAddToCart> createState() => _TAddToCartState();
}

class _TAddToCartState extends State<TAddToCart> {
  Color _selectedColor = Colors.black;
  String? selectedType;
  String? selectedFabric;
  String? selectedSleeve;
  String? selectedCollar;
  String? selectedFit;
  String? selectedLength;
  String? comment;

  final List<String> types = ['Topwear', 'Bottomwear'];
  final List<String> fabricTypes = [
    'Cotton',
    'Linen',
    'Silk',
    'Denim',
    'Wool',
    'Polyester',
    'Chiffon',
    'Velvet'
  ];
  final List<String> sleeveTypes = [
    'Short Sleeve',
    'Long Sleeve',
    'Sleeveless',
    'Half Sleeve',
    'Bell Sleeve',
    'Cuffed Sleeve',
    'Raglan Sleeve'
  ];
  final List<String> collarTypes = [
    'Round Neck',
    'V-Neck',
    'Collar',
    'Mandarin',
    'Hooded',
    'Turtleneck',
    'Peter Pan Collar',
    'Shawl Collar'
  ];
  final List<String> fitTypes = [
    'Slim Fit',
    'Regular Fit',
    'Loose Fit',
    'Tailored Fit',
    'Relaxed Fit',
    'Athletic Fit',
    'Oversized Fit'
  ];
  final List<String> lengthTypes = [
    'Full Length',
    'Ankle Length',
    'Knee Length',
    'Mini Length',
    'Midi Length',
    'Maxi Length',
    'Capri Length'
  ];

  final SessionController sessionController = Get.find();

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onAddToCartPressed() {
    if (selectedType == null || selectedFabric == null || selectedFit == null) {
      Get.snackbar(
        'Incomplete Selection',
        'Please select all required options',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final customizations = {
      'Color': _selectedColor.toString(),
      'Fabric': selectedFabric!,
      if (selectedType == 'Topwear') ...{
        'Sleeve': selectedSleeve ?? 'Not specified',
        'Collar': selectedCollar ?? 'Not specified',
      },
      if (selectedType == 'Bottomwear') ...{
        'Length': selectedLength ?? 'Not specified',
      },
      'Fit': selectedFit!,
      'Comment': comment ?? '',
    };

    final cartItem = CartItemModel(
      shopName: widget.shopName,
      style: widget.style,
      measurementType: sessionController.measurementType.value,
      appointmentDate: sessionController.appointmentDate.value,
      appointmentTime: sessionController.appointmentTime.value,
      brand: sessionController.selectedBrand.value,
      size: sessionController.selectedSize.value,
      customizations: customizations,
      quantity: 1,
    );

    sessionController.addItemToCart(cartItem);
    Get.off(() => NavigationMenu());
    Get.snackbar(
      'Success',
      'Item added to cart',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Customize Your ${widget.style}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color Selection Section
            _buildCustomizationCard(
              context: context,
              title: 'Choose Your Color',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Color:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      GestureDetector(
                        onTap: _openColorPicker,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            borderRadius:
                                BorderRadius.circular(TSizes.borderRadiusSm),
                            border: Border.all(
                              color: dark ? TColors.darkGrey : TColors.greay,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(TSizes.borderRadiusMd),
                      border: Border.all(
                        color: dark ? TColors.darkGrey : TColors.greay,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(TSizes.borderRadiusMd),
                      child: ModelViewer(
                        src: "assets/model/shirt_model.glb",
                        ar: true,
                        autoRotate: true,
                        cameraControls: true,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Garment Type Selection
            _buildCustomizationCard(
              context: context,
              title: 'Select Garment Type',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: types.map((type) {
                  return FilterChip(
                    label: Text(type),
                    selected: selectedType == type,
                    onSelected: (selected) {
                      setState(() {
                        selectedType = selected ? type : null;
                        // Clear dependent selections when type changes
                        if (selectedType != type) {
                          selectedSleeve = null;
                          selectedCollar = null;
                          selectedLength = null;
                        }
                      });
                    },
                    selectedColor: TColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selectedType == type ? Colors.white : null,
                    ),
                  );
                }).toList(),
              ),
            ),

            if (selectedType != null) ...[
              const SizedBox(height: TSizes.spaceBtwSections),

              // Fabric Selection
              _buildCustomizationCard(
                context: context,
                title: 'Select Fabric',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: fabricTypes.map((fabric) {
                    return FilterChip(
                      label: Text(fabric),
                      selected: selectedFabric == fabric,
                      onSelected: (selected) {
                        setState(() {
                          selectedFabric = selected ? fabric : null;
                        });
                      },
                      selectedColor: TColors.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selectedFabric == fabric ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            if (selectedType == 'Topwear' && selectedFabric != null) ...[
              const SizedBox(height: TSizes.spaceBtwSections),

              // Sleeve Style Selection
              _buildCustomizationCard(
                context: context,
                title: 'Sleeve Style',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sleeveTypes.map((sleeve) {
                    return FilterChip(
                      label: Text(sleeve),
                      selected: selectedSleeve == sleeve,
                      onSelected: (selected) {
                        setState(() {
                          selectedSleeve = selected ? sleeve : null;
                        });
                      },
                      selectedColor: TColors.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selectedSleeve == sleeve ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Collar Style Selection
              _buildCustomizationCard(
                context: context,
                title: 'Collar Style',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: collarTypes.map((collar) {
                    return FilterChip(
                      label: Text(collar),
                      selected: selectedCollar == collar,
                      onSelected: (selected) {
                        setState(() {
                          selectedCollar = selected ? collar : null;
                        });
                      },
                      selectedColor: TColors.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selectedCollar == collar ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            if (selectedType == 'Bottomwear' && selectedFabric != null) ...[
              const SizedBox(height: TSizes.spaceBtwSections),

              // Length Selection
              _buildCustomizationCard(
                context: context,
                title: 'Length',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: lengthTypes.map((length) {
                    return FilterChip(
                      label: Text(length),
                      selected: selectedLength == length,
                      onSelected: (selected) {
                        setState(() {
                          selectedLength = selected ? length : null;
                        });
                      },
                      selectedColor: TColors.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selectedLength == length ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            if (selectedFabric != null) ...[
              const SizedBox(height: TSizes.spaceBtwSections),

              // Fit Style Selection
              _buildCustomizationCard(
                context: context,
                title: 'Fit Style',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: fitTypes.map((fit) {
                    return FilterChip(
                      label: Text(fit),
                      selected: selectedFit == fit,
                      onSelected: (selected) {
                        setState(() {
                          selectedFit = selected ? fit : null;
                        });
                      },
                      selectedColor: TColors.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selectedFit == fit ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: TSizes.spaceBtwSections),

            // Special Instructions
            _buildCustomizationCard(
              context: context,
              title: 'Special Instructions',
              child: TextField(
                maxLines: 4,
                onChanged: (value) => comment = value,
                decoration: InputDecoration(
                  hintText: 'Any special requests or notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                    borderSide: BorderSide(
                      color: dark ? TColors.darkGrey : TColors.greay,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                    borderSide: const BorderSide(color: TColors.primary),
                  ),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onAddToCartPressed,
                child: const Text('ADD TO CART'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark ? TColors.darkerGrey : TColors.primary,
                  padding: const EdgeInsets.all(TSizes.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    final dark = THelperFunction.isDarkMode(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        side: BorderSide(
          color: dark ? TColors.darkerGrey : TColors.greay,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            child,
          ],
        ),
      ),
    );
  }
}
