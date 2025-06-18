import 'package:flutter/material.dart';
import 'package:tailormade/utils/constants/colors.dart';

class TShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: TColors.darkGrey.withAlpha(25),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0,2)
  );

  static final horizonatalProductShadow = BoxShadow(
      color: TColors.darkGrey.withAlpha(25),
      blurRadius: 50,
      spreadRadius: 7,
      offset: const Offset(0,2)
  );
}