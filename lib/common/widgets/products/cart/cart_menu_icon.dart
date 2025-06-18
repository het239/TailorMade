import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tailormade/features/shop/controllers/session_controller.dart';
import '../../../../features/shop/models/cartmodel.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../images/t_rounded_image.dart';
import '../../texts/t_tailor_title_with_verified_icon.dart';
import '../../texts/tailor_title_text.dart';
import 'add_remove_button.dart';

class TCartItem extends StatelessWidget {
  final CartItemModel item;
  final SessionController sessionController;

  const TCartItem({super.key, required this.item, required this.sessionController});

  @override
  Widget build(BuildContext context) {
    String formattedAppointment = '';
    if (item.appointmentDate.isNotEmpty && item.appointmentTime.isNotEmpty) {
      DateTime parsedDate = DateTime.parse(item.appointmentDate);
      String formattedDate = DateFormat('dd MMM, yyyy').format(parsedDate);
      formattedAppointment = '$formattedDate, ${item.appointmentTime}';
    }

    String imageUrl = TImages.getImageForService(item.style);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: THelperFunction.isDarkMode(context) ? TColors.dark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TRoundedImage(
                imageUrl: imageUrl.isNotEmpty ? imageUrl : TImages.shirt,
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(6),
                backgroundColor: THelperFunction.isDarkMode(context) ? TColors.dark : Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.shopName.isNotEmpty)
                      TTailorTitleWithVerifiedIcon(title: item.shopName),
                    if (item.style.isNotEmpty)
                      TTailorTitleText(title: item.style, maxLines: 1),
                    Wrap(
                      spacing: 6,
                      children: [
                        if (item.measurementType.isNotEmpty)
                          _buildDetailText(Icons.straighten, item.measurementType),
                        if (item.measurementType == 'HomeVisit' && formattedAppointment.isNotEmpty)
                          _buildDetailText(Icons.calendar_today, formattedAppointment),
                        if (item.brand.isNotEmpty)
                          _buildDetailText(Icons.branding_watermark, item.brand), // Brand type
                        if (item.size.isNotEmpty)
                          _buildDetailText(Icons.format_size, item.size), // Selected size
                      ],
                    ),
                    if (item.customizations.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: item.customizations.entries
                              .where((entry) => entry.key != 'Color' && entry.value.isNotEmpty)
                              .map((entry) => Chip(
                            label: Text('${entry.key}: ${entry.value}',
                                style: const TextStyle(fontSize: 10)),
                            backgroundColor: THelperFunction.isDarkMode(context)
                                ? TColors.dark
                                : Colors.white,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Observe the reactive price
              Obx(() => Text('₹${item.price.value.toStringAsFixed(2)}')), // Ensure the price is displayed here
              Row(
                children: [
                  TProductQuntityWithAddRemoveButton(
                    increment: () => sessionController.incrementQuantity(item),
                    decrement: () => sessionController.decrementQuantity(item),
                    quantity: item.quantity,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      sessionController.removeItemFromCart(item);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}