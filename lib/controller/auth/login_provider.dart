import 'dart:async' show Timer;
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/user.dart';
import '../../utils/helper/constants.dart';
import '../../utils/helper/helper.dart';
import '../../utils/services/local_storage.dart';
import '../../utils/services/toast.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/services/validation.dart';
import '../../view/auth/otp.dart';
import '../../view/auth/gender.dart';
import '../../view/nav/page.dart';

final loginProvider = ChangeNotifierProvider.autoDispose<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  //* Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var phoneNumberUtil = PhoneNumberUtil.instance;

  //* Login Variables
  bool isSendingOTP = false;
  BuildContext? context;
  var phoneNumberController = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromDialCode('+92');
  int numberDigits = 10;

  //* OTP Time Out Duration
  static const int _otpTimeOutDuration = 90;
  int _countDown = _otpTimeOutDuration;
  int get countDown => _countDown;
  set countDown(int value) {
    _countDown = value;
    notifyListeners();
  }

  //* OTP
  int? _forceResendingToken;
  String? _verificationId;
  bool isVerifyingOTP = false;
  Timer? bounceTimer;
  var otpController = TextEditingController();

  _resetOTPPage() {
    countDown = _otpTimeOutDuration;
    bounceTimer?.cancel();
    isSendingOTP = false;
    isVerifyingOTP = false;
    otpController.clear();
    notifyListeners();
  }

  //* Skip Login
  Future<void> skip(BuildContext context) async {
    LocalStorageManager.showLoginPage(false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectGenderPage()));
  }

  //* Send OTP To Phone Number
  Future<void> sendTheOTP(BuildContext context) async {
    this.context = context;
    final phoneError = simpleFieldValidation(phoneNumberController.text, LocaleKeys.phone_number.tr());
    if (phoneError != null) {
      errorToast(phoneError);
      return;
    }
    isSendingOTP = true;
    notifyListeners();
    await _auth.verifyPhoneNumber(
      phoneNumber: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!),
      timeout: const Duration(seconds: _otpTimeOutDuration),
      forceResendingToken: _forceResendingToken,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  //* Update Selected Country Code
  void updateSelectedCountry(CountryCode selectedCountry) async {
    this.selectedCountry = selectedCountry;
    var exampleNumber = phoneNumberUtil.getExampleNumber(selectedCountry.code ?? 'PK');
    numberDigits = exampleNumber?.nationalNumber.toString().length ?? 12;
    notifyListeners();
  }

  //* Fix The Phone number Format
  void onPhoneNumberTextFieldChanged(String number) async {
    if (number.startsWith('0') && number.length >= 8 && number.length <= 12) {
      phoneNumberController.text = number.substring(1);
      notifyListeners();
    }
  }

  //* Google Login
  void googleLogin(BuildContext context) async {
    LocalStorageManager.showSelectLanguagePage(true);
  }

  //* Facebook Login
  void facebookLogin(BuildContext context) async {
    LocalStorageManager.showSelectLanguagePage(true);
  }

  //* Apple Login
  void appleLogin(BuildContext context) async {
    LocalStorageManager.showSelectLanguagePage(true);
  }

  //* OTP Resend Verification Code Timer
  void _startBounceTimer() {
    bounceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDown < 1) {
        bounceTimer?.cancel();
        bounceTimer = null;
        notifyListeners();
      } else {
        countDown = countDown - 1;
      }
    });
    notifyListeners();
  }

  //* OTP Resend Verification Code
  void resendOTP() async {
    _startBounceTimer();
    await _auth.verifyPhoneNumber(
      phoneNumber: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!),
      timeout: const Duration(seconds: _otpTimeOutDuration),
      forceResendingToken: _forceResendingToken,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  //* OTP Verified
  void verifyOTP(BuildContext context) async {
    var otpError = simpleFieldValidation(LocaleKeys.otp_verification.tr(), otpController.text);
    if (otpError != null) {
      errorToast(otpError);
      return;
    }
    isVerifyingOTP = true;
    notifyListeners();
    final credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: otpController.text);
    var userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.additionalUserInfo!.isNewUser) {
      var timer = DateTime.now().toIso8601String();
      UserModel user = UserModel.fromMap({
        'uid': userCredential.user!.uid,
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'phone': userCredential.user!.phoneNumber,
        'photo': userCredential.user!.photoURL,
        'created_at': timer,
        'updated_at': timer,
      });
      await FirebaseFirestore.instance.collection(CollectionNames.users.name).doc(userCredential.user!.uid).set(user.toMap(), SetOptions(merge: true));
      await LocalStorageManager.saveUser(user);
      LocalStorageManager.showLoginPage(false);
      //* Disable Loading
      isVerifyingOTP = false;
      notifyListeners();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectGenderPage()));
    } else {
      var user = UserModel.fromMap((await FirebaseFirestore.instance.collection(CollectionNames.users.name).doc(userCredential.user!.uid).get()).data()!);
      await LocalStorageManager.saveUser(user);
      LocalStorageManager.showLoginPage(false);
      //* Disable Loading
      isVerifyingOTP = false;
      notifyListeners();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
    }
  }

  void _verificationFailed(error) {
    log('Error: ${error.code}');
    errorToast(error.message?.replaceAll('-', ' ').split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ') ?? 'Verification failed.');
    if (isSendingOTP) {
      isSendingOTP = false;
      notifyListeners();
    }
    if (bounceTimer != null) {
      bounceTimer?.cancel();
      bounceTimer = null;
      notifyListeners();
    }
  }

  void _onCodeSent(verificationId, forceResendingToken) async {
    _verificationId = verificationId;
    _forceResendingToken = forceResendingToken;
    if (isSendingOTP && context != null) {
      _startBounceTimer();
      await Navigator.push(context!, MaterialPageRoute(builder: (_) => OTPPage()));
      _resetOTPPage();
    }
  }

  void _verificationCompleted(phoneAuthCredential) {}

  void _codeAutoRetrievalTimeout(verificationId) => _verificationId = verificationId;

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    bounceTimer?.cancel();
    super.dispose();
  }
}
