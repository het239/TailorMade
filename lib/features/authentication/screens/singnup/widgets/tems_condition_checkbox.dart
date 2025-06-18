import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TTermsAndConditionCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const TTermsAndConditionCheckbox({super.key, required this.onChanged});

  @override
  _TTermsAndConditionCheckboxState createState() =>
      _TTermsAndConditionCheckboxState();
}

class _TTermsAndConditionCheckboxState
    extends State<TTermsAndConditionCheckbox> {
  bool isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() => isChecked = value ?? false);
    widget.onChanged(isChecked);
  }

  void _openTermsAndConditions() {
    Get.to(() => const TermsAndConditionsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: isChecked, onChanged: _toggleCheckbox),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                text: '${TTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: _openTermsAndConditions,
                  child: Text(
                    '${TTexts.privacyPolicy} ',
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark ? TColors.white : TColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ),
              TextSpan(
                text: '${TTexts.and} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: _openTermsAndConditions,
                  child: Text(
                    TTexts.termsOfUse,
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark ? TColors.white : TColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("1. Acceptance of Terms", theme),
                  _buildSectionText(
                      "By accessing or using our app, you agree to be bound by these Terms. If you do not agree, do not use our services.",
                      theme),

                  _buildSectionTitle("2. Services", theme),
                  _buildSectionText(
                      "TailorMade is a platform that connects users with tailors for stitching, alterations, and measurement services. We do not directly provide tailoring services; tailors on the platform are independent service providers.",
                      theme),

                  _buildSectionTitle("3. User Accounts", theme),
                  _buildSectionText(
                      "Users and tailors must register to use the app.\n"
                          "You agree to provide accurate information and keep it updated.\n"
                          "You are responsible for maintaining the confidentiality of your account.",
                      theme),

                  _buildSectionTitle("4. Tailor Responsibilities", theme),
                  _buildSectionText(
                      "Tailors must provide accurate service details and pricing.\n"
                          "Tailors are responsible for the quality and timeliness of their services.\n"
                          "TailorMade reserves the right to suspend or terminate accounts for violations.",
                      theme),

                  _buildSectionTitle("5. Payments", theme),
                  _buildSectionText(
                      "Users may pay through the app or as agreed with the tailor.\n"
                          "TailorMade may charge a commission from tailors for using the platform.",
                      theme),

                  _buildSectionTitle("6. Cancellations and Refunds", theme),
                  _buildSectionText(
                      "Cancellation and refund policies may vary by tailor and will be clearly mentioned.\n"
                          "Users are encouraged to review tailor-specific terms before booking.",
                      theme),

                  _buildSectionTitle("7. Liability", theme),
                  _buildSectionText(
                      "TailorMade is not liable for issues arising from tailor-user interactions.\n"
                          "We are not responsible for delays, damage, or dissatisfaction with services.",
                      theme),

                  _buildSectionTitle("8. Modifications", theme),
                  _buildSectionText(
                      "We reserve the right to modify these Terms at any time. Continued use of the app means you accept the updated Terms.",
                      theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4),
      child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSectionText(String text, ThemeData theme) {
    return Text(text, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5));
  }
}


