import 'package:flutter/material.dart';

class DeviceSize {
  static late double height;
  static late double width;
  static double figmascreensizeWidth = 390;
  static double figmascreensizeHeight = 844;

  static void setScreenSize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
  }
}
