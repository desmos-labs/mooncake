import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/colors.dart';

class TextThemes {
  // --- Login ---
  static TextStyle loginTitleTheme(BuildContext context) =>
      Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 32,
            color: Colors.white,
          );

  static TextStyle loginPopupTitleTheme(BuildContext context) =>
      Theme.of(context).textTheme.headline6.copyWith(
            fontSize: 16,
            color: ThemeColors.loginPopupTitleColor,
          );

  static TextStyle loginPopupTextTheme(BuildContext context) =>
      Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 14,
            color: ThemeColors.loginPopupTitleColor,
          );

  // --- Buttons ---
  static TextStyle primaryButtonTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.button.copyWith(
            color: ThemeColors.primaryButtonTextColor,
          );

  static TextStyle secondaryButtonTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.button.copyWith(
            color: ThemeColors.secondaryButtonTextColor,
          );
}
