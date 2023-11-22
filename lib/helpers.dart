import 'package:flutter/material.dart';

class Helpers {
  static bool isEmail(String text) {
    RegExp regexp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final bool emailValid = regexp.hasMatch(text);

    return emailValid;
  }

  static bool isTextEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  static void navigate({
    required BuildContext context,
    required Widget page,
    bool isReplacement = false,
  }) {
    if (isReplacement) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => page));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    }
  }

  static String? emailValidator(String? value) {
    String? emptyValidation = emptyTextValidator(value);
    if(emptyValidation != null){
      return emptyValidation;
    }
    if (!Helpers.isEmail(value!)) {
      return "Email is not in an accepted format";
    }
  }

  static String? emptyTextValidator(String? value) {
    if (isTextEmpty(value)) {
      return "Field can't be empty";
    }
  }

  // From https://medium.com/@nickysong/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    print("MATERIAL COLOR: $color, swatch: $swatch");
    return MaterialColor(color.value, swatch);
  }
}
