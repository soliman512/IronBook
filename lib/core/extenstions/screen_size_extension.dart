import 'package:flutter/material.dart';

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get keyboardInsets =>  MediaQuery.viewInsetsOf(this).bottom;
  bool get isKeyboardOpend =>  keyboardInsets > 0;
}
