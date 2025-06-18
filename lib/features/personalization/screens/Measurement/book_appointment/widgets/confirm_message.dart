import 'package:flutter/material.dart';
import 'package:tailormade/utils/constants/colors.dart';
import 'package:tailormade/utils/constants/sizes.dart';

class ConfirmMessage extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final bool dark;
  final VoidCallback onConfirm;

  const ConfirmMessage({
    required this.selectedDate,
    required this.selectedTime,
    required this.dark,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedDate == null || selectedTime == null
            ? null
            : onConfirm,
        child: const Text('Done'),
        style: ElevatedButton.styleFrom(
          backgroundColor: dark ? TColors.darkerGrey : TColors.black,
          padding: const EdgeInsets.all(TSizes.md),
          side: BorderSide(
            color: dark ? TColors.darkerGrey : TColors.black,
          ),
        ),
      ),
    );
  }
}