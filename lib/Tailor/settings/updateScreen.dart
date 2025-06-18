import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';

class UpdateServicePriceScreen extends StatefulWidget {
  final Map<String, dynamic> service; // Non-nullable for updating existing service

  const UpdateServicePriceScreen({super.key, required this.service});

  @override
  _UpdateServicePriceScreenState createState() => _UpdateServicePriceScreenState();
}

class _UpdateServicePriceScreenState extends State<UpdateServicePriceScreen> {
  final userController = Get.find<UserController>();
  final _supabase = Supabase.instance.client;
  late TextEditingController _priceController;
  bool _isServiceSelected = true;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.service['price'].toString());
  }

  Future<void> _updateService() async {
    final tailorId = userController.tailorId.value;
    if (tailorId.isEmpty) {
      Get.snackbar("Error", "Tailor ID not found.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      if (_isServiceSelected) {
        final price = double.tryParse(_priceController.text) ?? 0.0;
        final serviceData = {
          'price': price,
        };

        // Update existing service price
        await _supabase.from('tailorservices').update(serviceData).eq('tailor_id', tailorId).eq('service_name', widget.service['service_name']);
      } else {
        // Remove service
        await _supabase.from('tailorservices').delete().eq('tailor_id', tailorId).eq('service_name', widget.service['service_name']);
      }

      // Update userController with the new services
      await userController.fetchTailorServices();

      Get.back();
      Get.snackbar("Success", _isServiceSelected ? "Service price updated successfully." : "Service removed successfully.", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to update service: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Update Price',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Name
              Text(
                'Service: ${widget.service['service_name']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Price Input Field
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), // Add padding inside input field
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 10),

              // Service Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isServiceSelected,
                    onChanged: (value) {
                      setState(() {
                        _isServiceSelected = value ?? true;
                      });
                    },
                  ),
                  const Text('Service Active'),
                ],
              ),

              const SizedBox(height: 20),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateService,
                  child: const Text('Update Service'),
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