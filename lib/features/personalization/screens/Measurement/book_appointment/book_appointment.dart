import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailormade/features/personalization/screens/Measurement/book_appointment/widgets/confirm_message.dart';
import 'package:tailormade/features/personalization/screens/Measurement/book_appointment/widgets/date_time_picker.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';

import '../../../../shop/screens/add_to_cart/add_to_cart.dart';

class TTailorBookAppointment extends StatefulWidget {
  const TTailorBookAppointment({super.key});

  @override
  State<TTailorBookAppointment> createState() => _TTailorBookAppointmentState();
}

class _TTailorBookAppointmentState extends State<TTailorBookAppointment> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final SessionController sessionController = Get.find();

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Appointment'),
          content: Text(
              'Do you want to confirm the appointment on ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at ${_selectedTime!.format(context)}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                sessionController.setAppointmentDate(_selectedDate!);
                sessionController.setAppointmentTime(_selectedTime!);
                // Ensure the shop name is set correctly here
                // sessionController.setSelectedShopName("YourShopName"); // Replace "YourShopName" with the actual shop name
                Navigator.of(context).pop();
                Get.to(() => TAddToCart(
                  shopName: sessionController.selectedShopName.value,
                  style: sessionController.selectedStyle.value,)); // Navigate to the next screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Book Appointment',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date & Time:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Date & Time TextField
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: _selectedDate == null || _selectedTime == null
                    ? 'Choose Date & Time'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} - ${_selectedTime!.format(context)}',
                suffixIcon: IconButton(
                  icon: const Icon(Iconsax.calendar),
                  onPressed: () async {
                    final date = await DateTimePicker.selectDate(context, initialDate: _selectedDate);
                    final time = await DateTimePicker.selectTime(context, initialTime: _selectedTime);
                    setState(() {
                      _selectedDate = date;
                      _selectedTime = time;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Confirm Appointment Button
            ConfirmMessage(
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              dark: dark,
              onConfirm: () {
                if (_selectedDate != null && _selectedTime != null) {
                  _showConfirmationDialog(context);
                } else {
                  // Show an error message if date or time is not selected
                  Get.snackbar('Error', 'Please select date and time', backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}