
// This class contains all the App Images in String  formats.
class TImages {

  // -- App Logos
  static const String darkAppLogo = "assets/logos/sp_dark1.png";
  static const String lightAppLogo = "assets/logos/sp_light1.png";

  // -- Social Logos
  static const String google = "assets/logos/google-icon.png";
  static const String facebook = "assets/logos/facebook-icon.png";

  // -- OnBoarding Images
  static const String onBoardingImage1 = "assets/images/on_boarding_images/search3.png";
  static const String onBoardingImage2 = "assets/images/on_boarding_images/shopping.png";
  static const String onBoardingImage3 = "assets/images/on_boarding_images/delivery.png";

  // -- Animation
  static const String productIllustration = "";
  static const String productSaleIllustration = "";
  static const String staticSuccessIllustration = "assets/images/animations/staticSuccess.png";
  static const String deliveredInPlaneIllustration = "";
  static const String deliveredInEmailIllustration = "assets/images/animations/mail_check.png";
  static const String verifyIllustration = "";

  // -- Banners
  static const String promobanner1 = "assets/images/banners/bnr1.png";
  static const String promobanner2 = "assets/images/banners/bnr2.png";
  static const String promobanner3 = "assets/images/banners/bnr3.png";

  static const String tailorshop3 = "assets/images/tailor_profile/p2.png";


  static const String profil = "assets/images/container/tailor.png";
  static const String usesr = "assets/images/container/user.png";

  // -- Product Image
  static const String Blazer = "assets/images/tailor_profile/blazer.png";
  static const String kurta = "assets/images/tailor_profile/kurta.png";
  static const String pant = "assets/images/tailor_profile/pent.png";
  static const String shirt = "assets/images/tailor_profile/shirt.png";
  static const String pair = "assets/images/tailor_profile/pair.png";

  static String getImageForService(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'blazer':
        return Blazer;
      case 'kurta':
        return kurta;
      case 'pant':
        return pant;
      case 'shirt':
        return shirt;
      case 'pair':
        return pair;
      default:
        return ''; // Return a default or empty string if no match is found
    }
  }

  // Payment Methods
  static const String applepay = "assets/icons/payment_method/apple-pay.png";
  static const String googlepay = "assets/icons/payment_method/google-pay.png";
  static const String creditcard = "assets/icons/payment_method/credit-card.png";
  static const String mastercard = "assets/icons/payment_method/master-card.png";
  static const String paypal = "assets/icons/payment_method/pay-pal.png";
  static const String visa = "assets/icons/payment_method/visa.png";
  static const String paytm = "assets/icons/payment_method/paytm.png";
  static const String successfullPayment = "assets/icons/payment_method/success.gif";

  // Measured Icon
  static const String biceps = "assets/icons/Measurement/Biceps.png";
  static const String crotch = "assets/icons/Measurement/Crotch.png";
  static const String inseam = "assets/icons/Measurement/inseam.png";
  static const String shoulder_width = "assets/icons/Measurement/Shoulder_width.png";
  static const String sleeve_length = "assets/icons/Measurement/Sleeve_length.png";
  static const String thighs = "assets/icons/Measurement/thighs.png";
  static const String waist = "assets/icons/Measurement/Waist.png";
  static const String waist_to_ankle = "assets/icons/Measurement/waist_to_ankle.png";
  static const String wrist = "assets/icons/Measurement/wrist.png";
  static const String shoulder = "assets/icons/Measurement/shoulder.png";
  static const String chest = "assets/icons/Measurement/chest.png";


}