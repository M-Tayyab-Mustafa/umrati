import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/utils/services/local_storage.dart';

import '../../model/country.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/toast.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/services/validation.dart';
import '../../view/auth/otp.dart';
import '../../view/auth/sign_up.dart';
import 'otp_provider.dart';

final loginProvider = ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier(ref: ref));

class LoginNotifier extends ChangeNotifier {
  LoginNotifier({required this.ref});
  final Ref ref;
  static List<Country> countries = [Country(icon: 'assets/png/flag.png', code: '+92')];
  bool isSendingOTP = false;
  var phoneNumberController = TextEditingController();
  Country selectedCountry = countries.first;

  Future<void> sendTheOTP(BuildContext context) async {
    var phoneError = simpleFieldValidation(phoneNumberController.text, LocaleKeys.phone_number.tr());
    if (phoneError != null) {
      errorToast(phoneError);
      return;
    }
    isSendingOTP = true;
    notifyListeners();
    ref.read(otpProvider.notifier).phoneNumber = phoneNumberController.text;
    //TODO: Send OTP API
    isSendingOTP = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => OTPPage()));
  }

  Future<void> skip(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  void updateSelectedCountry(BuildContext context) async {
    var result = await showMenu<Country>(
      context: context,
      items: countries.map((country) => PopupMenuItem<Country>(value: country, child: Text(country.code))).toList(),

      positionBuilder: (context, rect) => RelativeRect.fromLTRB(screenSize.width * 0.21, screenSize.height * 0.36, screenSize.width, screenSize.height),
    );
    if (result != null) {
      selectedCountry = result;
      notifyListeners();
    }
  }

  void googleLogin(BuildContext context) async {
    LocalStorageManager.saveFirstTime(true);
  }

  void facebookLogin(BuildContext context) async {
    LocalStorageManager.saveFirstTime(true);
  }

  void appleLogin(BuildContext context) async {
    LocalStorageManager.saveFirstTime(true);
  }
}
