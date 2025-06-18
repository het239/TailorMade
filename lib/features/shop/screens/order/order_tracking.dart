import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TOrderTracking extends StatelessWidget {
  const TOrderTracking({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    // Example order status
    final List<String> orderStatus = [
      'Order Placed',
      'Accepted',
      'Get Measured',
      'In Progress',
      'Delivered',
      'Complete',
    ];

    // Current step (e.g., 2 means "Get Measured" is the current step)
    final int currentStep = 2;

    return Scaffold(
      appBar: TAppBar(
          title: Text('Order Tracking',
              style: Theme.of(context).textTheme.headlineSmall),
          showBackArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #12345',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            _buildTimeline(orderStatus, currentStep, dark),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(List<String> orderStatus, int currentStep, bool dark) {
    return Column(
      children: List.generate(orderStatus.length, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Timeline Indicator
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                        ? TColors.primary
                        : isCompleted
                        ? TColors.success
                        : dark
                        ? TColors.darkerGrey
                        : TColors.greay,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check,
                      size: 16, color: TColors.textWhite)
                      : null,
                ),
                if (index < orderStatus.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? TColors.success
                        : dark
                        ? TColors.darkerGrey
                        : TColors.greay,
                  ),
              ],
            ),
            const SizedBox(width: 16),

            /// Status Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderStatus[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent
                          ? TColors.primary
                          : (dark ? TColors.textWhite : TColors.textPrimary),
                    ),
                  ),
                  if (isCurrent || isCompleted)
                    Text(
                      _getStatusMessage(orderStatus[index]),
                      style: TextStyle(color: TColors.textSecondaru),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'Order Placed':
        return 'Your order has been placed.';
      case 'Accepted':
        return 'Your order has been accepted.';
      case 'Get Measured':
        return 'Your order is being measured.';
      case 'In Progress':
        return 'Your order is being prepared for stitching.';
      case 'Delivered':
        return 'Your order has been delivered.';
      case 'Complete':
        return 'Your order is complete.';
      default:
        return 'Your order status is unknown.';
    }
  }
}
