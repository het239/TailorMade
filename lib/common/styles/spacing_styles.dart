import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWthAppBarHeight = EdgeInsets.only(
    top:  TSizes.appBarHeight,
    left: TSizes.defaultSpace,
    bottom: TSizes.defaultSpace,
    right: TSizes.defaultSpace,
  );
}