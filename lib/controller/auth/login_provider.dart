import '../../export.dart';
import '../../view/auth/otp.dart';

final loginProvider = ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // void _codeAutoRetrievalTimeout(verificationId) => _verificationId = verificationId;

  bool isSendingOTP = false;
  bool isSocialLogin = false;
  var emailController = TextEditingController();
  // var phoneNumberController = TextEditingController();
  // CountryCode selectedCountry = CountryCode.fromDialCode('+92');

  static const int _otpTimeOutDuration = 90;
  int _countDown = _otpTimeOutDuration;
  int get countDown => _countDown;
  set countDown(int value) {
    _countDown = value;
    notifyListeners();
  }

  // int? _forceResendingToken;
  // String? _verificationId;
  String? _verificationCode;
  bool isVerifyingOTP = false;
  Timer? bounceTimer;
  var otpController = TextEditingController();

  resetPage() {
    countDown = _otpTimeOutDuration;
    bounceTimer?.cancel();
    isSendingOTP = false;
    isVerifyingOTP = false;
    isSocialLogin = false;
    otpController.clear();
    notifyListeners();
  }

  Future<void> sendTheOTP(BuildContext context) async {
    try {
      _verificationCode = Helper.generateOTP();
      final email = emailController.text.trim();
      final emailError = simpleFieldValidation(email, LocaleKeys.email.tr(), context);
      if (emailError != null) {
        errorToast(emailError);
        return;
      }
      isSendingOTP = true;
      notifyListeners();
      await otpCollection.doc(email).set(OTPModel(otpCode: _verificationCode!).toMap(expiredAt: FieldValue.serverTimestamp()));
      var otpService = OTPModel.fromMap((await otpCollection.doc(email).get()).data()!);
      final newExpiredAt = otpService.expiredAt!.toDate().add(const Duration(minutes: 10));
      otpService = otpService.copyWith(otpCode: _verificationCode, expiredAt: Timestamp.fromDate(newExpiredAt));
      await otpCollection.doc(email).update(otpService.toMap());
      var response = await Helper.sendEmail(email, _verificationCode!);
      appLog(response.toString());
      isSendingOTP = false;
      notifyListeners();
      if (response.status == 200) {
        _startBounceTimer();
        var isAutoPop = await Navigator.push(context, MaterialPageRoute(builder: (_) => OTPPage()));
        if (isAutoPop != true) resetPage();
      }
      // final phoneNumberFormateError = validatePhoneNumber(Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!), selectedCountry.code!);
      // if (phoneNumberFormateError != null) {
      //   errorToast(phoneNumberFormateError);
      //   return;
      // }
      // isSendingOTP = true;
      // notifyListeners();
      // await _auth
      //     .verifyPhoneNumber(
      //       phoneNumber: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!),
      //       timeout: const Duration(seconds: _otpTimeOutDuration),
      //       forceResendingToken: _forceResendingToken,
      //       verificationCompleted: _verificationCompleted,
      //       verificationFailed: (e) {
      //         isSendingOTP = false;
      //         notifyListeners();
      //         if (bounceTimer != null) {
      //           bounceTimer?.cancel();
      //           bounceTimer = null;
      //           notifyListeners();
      //         }
      //         _firebaseAuthExceptionHandler(e);
      //       },
      //       codeSent: (verificationId, forceResendingToken) => _onCodeSent(context, verificationId, forceResendingToken),
      //       codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      //     )
      //     .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
      isSendingOTP = false;
      notifyListeners();
    }
  }

  // void updateSelectedCountry(CountryCode selectedCountry) async {
  //   this.selectedCountry = selectedCountry;
  //   notifyListeners();
  // }

  void googleLogin(BuildContext context, WidgetRef ref) async {
    try {
      isSocialLogin = true;
      notifyListeners();
      await SocialLoginService.instance.signInWithGoogle(context, ref);
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    } finally {
      isSocialLogin = false;
      notifyListeners();
    }
  }

  // void facebookLogin(BuildContext context, WidgetRef ref) async {
  //   try {
  //     isSocialLogin = true;
  //     notifyListeners();
  //     await SocialLoginService.instance.signInWithFacebook(context, ref);
  //   } catch (e) {
  //     appLog(e.toString());
  //     errorToast(LocaleKeys.some_thing_went_wrong.tr());
  //     isSocialLogin = false;
  //     notifyListeners();
  //   } finally {
  //     isSocialLogin = false;
  //     notifyListeners();
  //   }
  // }

  void appleLogin(BuildContext context, WidgetRef ref) async {
    try {
      isSocialLogin = true;
      notifyListeners();
      await SocialLoginService.instance.signInWithApple(context, ref);
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
      isSocialLogin = false;
      notifyListeners();
    } finally {
      isSocialLogin = false;
      notifyListeners();
    }
  }

  void _startBounceTimer() {
    _countDown = _otpTimeOutDuration;
    notifyListeners();
    bounceTimer?.cancel();
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

  void resendOTP(BuildContext context) async {
    try {
      isSendingOTP = true;
      _startBounceTimer();
      _verificationCode = Helper.generateOTP();
      final email = emailController.text.trim();
      var otpService = OTPModel.fromMap((await otpCollection.doc(email).get()).data()!);
      final newExpiredAt = otpService.expiredAt!.toDate().add(const Duration(minutes: 10));
      otpService = otpService.copyWith(otpCode: _verificationCode, expiredAt: Timestamp.fromDate(newExpiredAt));
      await otpCollection.doc(email).update(otpService.toMap());
      var response = await Helper.sendEmail(email, _verificationCode!);
      appLog(response.toString());
      isSendingOTP = false;
      notifyListeners();
      // await _auth
      //     .verifyPhoneNumber(
      //       phoneNumber: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!),
      //       timeout: const Duration(seconds: _otpTimeOutDuration),
      //       forceResendingToken: _forceResendingToken,
      //       verificationCompleted: _verificationCompleted,
      //       verificationFailed: (e) {
      //         isSendingOTP = false;
      //         notifyListeners();
      //         if (bounceTimer != null) {
      //           bounceTimer?.cancel();
      //           bounceTimer = null;
      //           notifyListeners();
      //         }
      //         _firebaseAuthExceptionHandler(e);
      //       },
      //       codeSent: (verificationId, forceResendingToken) => _onCodeSent(context, verificationId, forceResendingToken),
      //       codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      //     )
      //     .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }

  void verifyOTP(BuildContext context, WidgetRef ref) async {
    var otpError = simpleFieldValidation(LocaleKeys.otp_verification.tr(), otpController.text, context);
    if (otpError != null) {
      errorToast(otpError);
      return;
    }
    isVerifyingOTP = true;
    notifyListeners();
    try {
      final email = emailController.text.trim();
      final bool validOTP = await _isValidOTP();
      if (validOTP) {
        final querySnapshot = await userCollection.where('email', isEqualTo: email).get().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
        if (querySnapshot.docs.isEmpty) {
          final password = Helper.generateRandomId();
          final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          UserModel user = UserModel(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email ?? email,
            is_premium: false,
            photo: userCredential.user!.photoURL ?? '',
            password: password,
            gender: '',
          );
          await LocalStorageManager.saveUser(user, created_at: FieldValue.serverTimestamp());
          ref.read(splashProvider.notifier).redirections(context);
        } else {
          final user = UserModel.fromMap(querySnapshot.docs.first.data());
          final credential = EmailAuthProvider.credential(email: email, password: user.password);
          await _auth.signInWithCredential(credential).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
          await LocalStorageManager.saveUser(user, toFirebase: false);
          ref.read(splashProvider.notifier).redirections(context);
        }
      } else {
        errorToast(LocaleKeys.invalid_verification_code.tr());
      }
    } on FirebaseAuthException catch (e) {
      isVerifyingOTP = false;
      notifyListeners();
      _firebaseAuthExceptionHandler(e);
    } catch (e) {
      appLog(e.toString());
      isVerifyingOTP = false;
      notifyListeners();
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    } finally {
      isVerifyingOTP = false;
      notifyListeners();
    }
  }

  Future<bool> _isValidOTP() async {
    final email = emailController.text.trim();
    final doc = await otpCollection.doc(email).get();

    if (!doc.exists) return false;
    OTPModel otpService = OTPModel.fromMap(doc.data()!);

    if (DateTime.now().isAfter(otpService.expiredAt!.toDate())) return false;
    return otpService.otpCode == otpController.text.trim();
  }

  void _firebaseAuthExceptionHandler(FirebaseAuthException error) {
    appLog('Code: ${error.code}, Message: ${error.message}');
    switch (error.code) {
      case 'missing-phone-number':
        errorToast(LocaleKeys.missing_phone_number.tr());
        break;
      case 'invalid-phone-number':
        errorToast(LocaleKeys.invalid_phone_number.tr());
        break;
      case 'missing-verification-code':
        errorToast(LocaleKeys.missing_verification_code.tr());
        break;
      case 'invalid-verification-code':
        errorToast(LocaleKeys.invalid_verification_code.tr());
        break;
      case 'missing-verification-id':
        errorToast(LocaleKeys.missing_verification_id.tr());
        break;
      case 'invalid-verification-id':
        errorToast(LocaleKeys.invalid_verification_id.tr());
        break;
      case 'code-expired':
        errorToast(LocaleKeys.code_expired.tr());
        break;
      case 'captcha-check-failed':
        errorToast(LocaleKeys.captcha_check_failed.tr());
        break;
      case 'quota-exceeded':
        errorToast(LocaleKeys.quota_exceeded.tr());
        break;
      case 'app-not-verified':
        errorToast(LocaleKeys.app_not_verified.tr());
        break;
      case 'invalid-email':
        errorToast(LocaleKeys.invalid_email.tr());
        break;
      case 'user-disabled':
        errorToast(LocaleKeys.user_disabled.tr());
        break;
      case 'user-not-found':
        errorToast(LocaleKeys.user_not_found.tr());
        break;
      case 'wrong-password':
        errorToast(LocaleKeys.wrong_password.tr());
        break;
      case 'email-already-in-use':
        errorToast(LocaleKeys.email_already_in_use.tr());
        break;
      case 'weak-password':
        errorToast(LocaleKeys.weak_password.tr());
        break;
      case 'expired-action-code':
        errorToast(LocaleKeys.expired_action_code.tr());
        break;
      case 'invalid-action-code':
        errorToast(LocaleKeys.invalid_action_code.tr());
        break;
      case 'account-exists-with-different-credential':
        errorToast(LocaleKeys.account_exists_with_different_credential.tr());
        break;
      case 'invalid-credential':
        errorToast(LocaleKeys.invalid_credential.tr());
        break;
      case 'credential-already-in-use':
        errorToast(LocaleKeys.credential_already_in_use.tr());
        break;
      case 'provider-already-linked':
        errorToast(LocaleKeys.provider_already_linked.tr());
        break;
      case 'no-such-provider':
        errorToast(LocaleKeys.no_such_provider.tr());
        break;
      case 'requires-recent-login':
        errorToast(LocaleKeys.requires_recent_login.tr());
        break;
      case 'multi-factor-auth-required':
      case 'second-factor-required':
        errorToast(LocaleKeys.multi_factor_auth_required.tr());
        break;
      case 'too-many-requests':
        errorToast(LocaleKeys.too_many_requests.tr());
        break;
      case 'network-request-failed':
        errorToast(LocaleKeys.network_request_failed.tr());
        break;
      case 'operation-not-allowed':
        errorToast(LocaleKeys.operation_not_allowed.tr());
        break;
      case 'internal-error':
        errorToast(LocaleKeys.internal_error.tr());
        break;
      default:
        errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }

  // void _onCodeSent(BuildContext context, verificationId, forceResendingToken) async {
  //   isSendingOTP = false;
  //   notifyListeners();
  //   _verificationId = verificationId;
  //   _forceResendingToken = forceResendingToken;
  //   _startBounceTimer();
  //   var isAutoPop = await Navigator.push(context, MaterialPageRoute(builder: (_) => OTPPage()));
  //   if (isAutoPop != true) resetPage();
  // }

  // void _verificationCompleted(phoneAuthCredential) {
  //   isSendingOTP = false;
  //   notifyListeners();
  // }

  @override
  void dispose() {
    // phoneNumberController.dispose();
    otpController.dispose();
    bounceTimer?.cancel();
    super.dispose();
  }
}
