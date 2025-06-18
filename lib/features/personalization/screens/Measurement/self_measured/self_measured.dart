import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailormade/features/shop/screens/add_to_cart/add_to_cart.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';

class TTailorSelfMeasured extends StatefulWidget {
  const TTailorSelfMeasured({super.key});

  @override
  State<TTailorSelfMeasured> createState() => _TTailorSelfMeasuredState();
}

class _TTailorSelfMeasuredState extends State<TTailorSelfMeasured> {
  String? selectedBrand;
  String? selectedSize;
  final SessionController sessionController = Get.find();
  final SupabaseClient supabase = Supabase.instance.client;
  List<String> brandNames = [];
  List<String> sizes = [];

  @override
  void initState() {
    super.initState();
    fetchBrandsAndSizes();
  }

  Future<void> fetchBrandsAndSizes() async {
    try {
      final response = await supabase
          .from('selfmeasurements')
          .select('brand_name, size')
          .eq('clothing_type', sessionController.selectedStyle.value);

      final data = response as List<dynamic>;
      final brandsSet = <String>{};
      final sizesSet = <String>{};

      for (final item in data) {
        brandsSet.add(item['brand_name']);
        sizesSet.add(item['size']);
      }

      setState(() {
        brandNames = brandsSet.toList();
        sizes = sizesSet.toList();
      });
    } catch (e) {
      print("Error fetching brands and sizes: $e");
    }
  }

  void _onDonePressed() {
    if (selectedBrand == null || selectedSize == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select both a brand and a size.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      sessionController.setSelectedBrand(selectedBrand!);
      sessionController.setSelectedSize(selectedSize!);
      // Ensure the shop name is set correctly here
      // sessionController.setSelectedShopName("YourShopName"); // Replace "YourShopName" with the actual shop name
      Get.to(() => TAddToCart(
        shopName: sessionController.selectedShopName.value,
        style: sessionController.selectedStyle.value,));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Self Measured',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Display selected style
              Text(
                'Selected Style: ${sessionController.selectedStyle.value}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Brand Dropdown
              const SizedBox(height: TSizes.spaceBtwSections),
              Text('Brand', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: TSizes.spaceBtwItems),
              DropdownButtonFormField<String>(
                value: selectedBrand,
                hint: const Text('Select a brand'),
                onChanged: (value) {
                  setState(() {
                    selectedBrand = value;
                  });
                },
                items: brandNames
                    .map((brand) => DropdownMenuItem<String>(
                  value: brand,
                  child: Text(brand),
                ))
                    .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                ),
              ),

              /// Size Dropdown
              const SizedBox(height: TSizes.spaceBtwSections),
              Text('Size', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: TSizes.spaceBtwItems),
              DropdownButtonFormField<String>(
                value: selectedSize,
                hint: const Text('Select a size'),
                onChanged: (value) {
                  setState(() {
                    selectedSize = value;
                  });
                },
                items: sizes
                    .map((size) => DropdownMenuItem<String>(
                  value: size,
                  child: Text(size),
                ))
                    .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onDonePressed,
                  child: const Text('Done'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark ? TColors.darkerGrey : TColors.black,
                    padding: const EdgeInsets.all(TSizes.md),
                    side: BorderSide(
                      color: dark ? TColors.darkerGrey : TColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}