import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/auth/sign_up.dart';

final otpProvider = ChangeNotifierProvider<OTPNotifier>((ref) => OTPNotifier());

class OTPNotifier extends ChangeNotifier {
  String? _phoneNumber;
  set phoneNumber(String number) => _phoneNumber = number;
  String get phoneNumber => _phoneNumber ?? '';
  bool isVerifyingOTP = false;
  var otpController = TextEditingController();

  void verifyOTP(BuildContext context) {
    isVerifyingOTP = true;
    notifyListeners();
    //TODO: Verify OTP
    isVerifyingOTP = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
