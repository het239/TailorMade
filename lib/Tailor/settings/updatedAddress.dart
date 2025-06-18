import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../features/authentication/controllers.onboarding/user_controller.dart';

class UpdateAddressScreen extends StatefulWidget {
  final Map<String, dynamic> address;

  const UpdateAddressScreen({Key? key, required this.address}) : super(key: key);

  @override
  _UpdateAddressScreenState createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  final userController = Get.find<UserController>();

  late String? _addressType;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _addressType = widget.address['address_type'];
    _streetController = TextEditingController(text: widget.address['street']);
    _cityController = TextEditingController(text: widget.address['city']);
    _stateController = TextEditingController(text: widget.address['state']);
    _postalCodeController = TextEditingController(text: widget.address['postal_code']);
    _latitudeController = TextEditingController(text: widget.address['latitude'].toString());
    _longitudeController = TextEditingController(text: widget.address['longitude'].toString());
  }

  Future<void> _updateAddress() async {
    if (_formKey.currentState!.validate()) {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }
      try {
        await _supabase.from('addresses').update({
          'address_type': _addressType,
          'street': _streetController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'postal_code': _postalCodeController.text,
          'latitude': double.tryParse(_latitudeController.text) ?? 0.0,
          'longitude': double.tryParse(_longitudeController.text) ?? 0.0,
        }).eq('address_id', widget.address['address_id']);

        // Update userController with the updated address details
        userController.fetchUserAddresses();

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating address: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Update Address')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.category),
                  labelText: 'Address Type',
                ),
                value: _addressType,
                items: ['Home', 'Work', 'Other'] // Use allowed values here
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => _addressType = value),
                validator: (value) => value == null ? 'Please select an address type' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.building_31),
                  labelText: 'Street',
                ),
                validator: (value) => value!.isEmpty ? 'Enter street' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.building),
                        labelText: 'City',
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter city' : null,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.activity),
                        labelText: 'State',
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter state' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.code),
                  labelText: 'Postal Code',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter postal code' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.global),
                        labelText: 'Latitude',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter latitude' : null,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.global),
                        labelText: 'Longitude',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter longitude' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.defaultSpace),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateAddress,
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}