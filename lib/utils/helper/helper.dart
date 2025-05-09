import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

class Helper {
  static String formatePhoneNumber(String phoneNumber, String dialCode) {
    return '$dialCode${phoneNumber.replaceAll(' ', '')}';
  }
}

class UsPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length && i < 10; i++) {
      if (i == 3) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }

    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}
