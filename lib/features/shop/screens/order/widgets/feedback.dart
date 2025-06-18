
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

/// Feedback Dialog as a StatefulWidget
class FeedbackDialog extends StatefulWidget {
  final int orderIndex;

  const FeedbackDialog({super.key, required this.orderIndex});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  int _selectedRating = 0; // Tracks the selected rating

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Feedback'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How was your experience with this order?'),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Black border for all stars
                      width: 2.0,
                    ),
                    color: index < _selectedRating
                        ? Colors.yellow // Yellow fill for selected stars
                        : Colors.transparent, // Transparent for unselected stars
                  ),
                  child: Icon(
                    Icons.star,
                    size: 24,
                    color: index < _selectedRating
                        ? Colors.black // Black icon for selected stars
                        : Colors.black.withOpacity(0.3), // Faded black for unselected stars
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedRating = index + 1; // Update the selected rating
                  });
                },
              );
            }),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Add a comment (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle feedback submission
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feedback submitted!')),
            );
            print(
                'Feedback submitted for order ${widget.orderIndex} with rating $_selectedRating');
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}