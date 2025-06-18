import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import 'package:tailormade/features/authentication/controllers.onboarding/user_controller.dart';

class TailorServiceScreen extends StatefulWidget {
  final Map<String, dynamic>? service; // Nullable for new services

  const TailorServiceScreen({super.key, this.service});

  @override
  _TailorServiceScreenState createState() => _TailorServiceScreenState();
}

class _TailorServiceScreenState extends State<TailorServiceScreen> {
  final userController = Get.find<UserController>();
  final _supabase = Supabase.instance.client;
  late Map<String, TextEditingController> _controllers;
  late Map<String, bool> _selectedServices;
  final List<String> allServices = ['Pant', 'Shirt', 'Pair', 'Blazer', 'Kurta'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeSelectedServices();
  }

  void _initializeControllers() {
    _controllers = {
      'Pant': TextEditingController(),
      'Shirt': TextEditingController(),
      'Pair': TextEditingController(),
      'Blazer': TextEditingController(),
      'Kurta': TextEditingController(),
    };

    // If editing existing service, fill in existing data
    if (widget.service != null) {
      String serviceName = widget.service!['service_name'];
      double price = widget.service!['price'];
      if (_controllers.containsKey(serviceName)) {
        _controllers[serviceName]!.text = price.toString();
      }
    }
  }

  void _initializeSelectedServices() {
    _selectedServices = {
      'Pant': false,
      'Shirt': false,
      'Pair': false,
      'Blazer': false,
      'Kurta': false,
    };

    // If editing existing service, mark the service as selected
    if (widget.service != null) {
      String serviceName = widget.service!['service_name'];
      if (_selectedServices.containsKey(serviceName)) {
        _selectedServices[serviceName] = true;
      }
    }
  }

  Future<void> _saveServices() async {
    final tailorId = userController.tailorId.value;
    if (tailorId.isEmpty) {
      Get.snackbar("Error", "Tailor ID not found.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      for (var service in _selectedServices.entries) {
        if (service.value) {
          final price = double.tryParse(_controllers[service.key]!.text) ?? 0.0;
          final serviceData = {
            'tailor_id': tailorId,
            'service_name': service.key,
            'price': price,
          };

          if (widget.service == null) {
            // Insert new service
            await _supabase.from('tailorservices').insert(serviceData);
          } else {
            // Upsert service (insert or update)
            await _supabase.from('tailorservices').upsert(serviceData, onConflict: 'tailor_id');
            await _supabase.from('tailorservices').upsert(serviceData, onConflict: 'service_name');
          }
        }
      }

      // Update userController with the new services
      await userController.fetchTailorServices();

      // Clear form fields after adding services
      _initializeControllers();
      _initializeSelectedServices();
      setState(() {});

      Get.back();
      Get.snackbar("Success", "Services updated successfully.", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to update services: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    // Filter out services that have already been added
    List<String> remainingServices = allServices.where((service) {
      return !userController.services.any((existingService) => existingService['service_name'] == service);
    }).toList();

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Services',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (remainingServices.isNotEmpty) ...[
                // Service Offered & Charges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Service Offered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Service Charges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
              ],

              ...remainingServices.map((service) => _buildServiceCheckbox(service)).toList(),

              if (remainingServices.isEmpty)
                const Center(child: Text('No services remaining to add')),

              const SizedBox(height: 20),

              // Save Button
              if (remainingServices.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveServices,
                    child: const Text('Save'),
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

  // Function to create a service checkbox with charge input field
  Widget _buildServiceCheckbox(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // Add padding between rows
      child: Row(
        children: [
          Checkbox(
            value: _selectedServices[title],
            onChanged: (value) {
              setState(() {
                _selectedServices[title] = value ?? false;
              });
            },
          ),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _controllers[title],
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), // Add padding inside input field
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}