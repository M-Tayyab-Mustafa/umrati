import '../../export.dart';
import '../../view/auth/otp.dart';

final loginProvider = ChangeNotifierProvider.autoDispose<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _codeAutoRetrievalTimeout(verificationId) => _verificationId = verificationId;

  bool isSendingOTP = false;
  bool isSocialLogin = false;
  var phoneNumberController = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromDialCode('+92');
  int sendOTPTimeMultiplier = 1;
  bool isLinkingAccount = false;

  static const int _otpTimeOutDuration = 90;
  int _countDown = _otpTimeOutDuration;
  int get countDown => _countDown;
  set countDown(int value) {
    _countDown = value;
    notifyListeners();
  }

  int? _forceResendingToken;
  String? _verificationId;
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

  Future<void> sendTheOTP(BuildContext context, [bool isLinkingAccount = false]) async {
    try {
      this.isLinkingAccount = isLinkingAccount;
      final phoneError = simpleFieldValidation(phoneNumberController.text, LocaleKeys.phone_number.tr(), context);
      if (phoneError != null) {
        errorToast(phoneError);
        return;
      }
      final phoneNumberFormateError = validatePhoneNumber(Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!), selectedCountry.code!);
      if (phoneNumberFormateError != null) {
        errorToast(phoneNumberFormateError);
        return;
      }
      isSendingOTP = true;
      notifyListeners();
      await _auth
          .verifyPhoneNumber(
            phoneNumber: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!),
            timeout: const Duration(seconds: _otpTimeOutDuration),
            forceResendingToken: _forceResendingToken,
            verificationCompleted: _verificationCompleted,
            verificationFailed: _verificationFailed,
            codeSent: (verificationId, forceResendingToken) => _onCodeSent(context, verificationId, forceResendingToken),
            codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
          )
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }

  void updateSelectedCountry(CountryCode selectedCountry) async {
    this.selectedCountry = selectedCountry;
    notifyListeners();
  }

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

  void facebookLogin(BuildContext context, WidgetRef ref) async {
    try {
      isSocialLogin = true;
      notifyListeners();
      await SocialLoginService.instance.signInWithFacebook(context, ref);
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
      sendOTPTimeMultiplier++;
      _startBounceTimer();
      await _auth
          .verifyPhoneNumber(
            phoneNumber: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!),
            timeout: const Duration(seconds: _otpTimeOutDuration),
            forceResendingToken: _forceResendingToken,
            verificationCompleted: _verificationCompleted,
            verificationFailed: _verificationFailed,
            codeSent: (verificationId, forceResendingToken) => _onCodeSent(context, verificationId, forceResendingToken),
            codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
          )
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
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
      final credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: otpController.text);
      if (isLinkingAccount) {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        await LocalStorageManager.saveUser((await LocalStorageManager.getUser(fromFirebase: true))!.copyWith(phone: phoneNumberController.text.trim(), country_code: selectedCountry.dialCode ?? ''));
        infoToast(LocaleKeys.account_linked_successfully.tr());
        ref.read(splashProvider.notifier).redirections(context);
      } else {
        var userCredential = await _auth.signInWithCredential(credential).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel user = UserModel(uid: userCredential.user!.uid, phone: userCredential.user!.phoneNumber ?? '', country_code: selectedCountry.dialCode ?? '', name: '', email: '', photo: '', password: Helper.generateRandomId(), gender: '');
          await LocalStorageManager.saveUser(user, created_at: FieldValue.serverTimestamp());
          ref.read(splashProvider.notifier).redirections(context);
        } else {
          await LocalStorageManager.saveUser(UserModel.fromMap((await userCollection.doc(userCredential.user!.uid).get()).data()!), toFirebase: false);
          ref.read(splashProvider.notifier).redirections(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      isVerifyingOTP = false;
      notifyListeners();
      if (e.code == 'unknown') {
        errorToast(LocaleKeys.some_thing_went_wrong.tr());
      } else {
        errorToast(e.message.toString());
      }
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

  void _verificationFailed(FirebaseAuthException error) {
    isSendingOTP = false;
    notifyListeners();
    appLog('Code: ${error.code}, Message: ${error.message}');
    if (error.code == 'unknown') {
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    } else {
      errorToast(error.message?.replaceAll('-', ' ').split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ') ?? 'Verification failed.');
      if (bounceTimer != null) {
        bounceTimer?.cancel();
        bounceTimer = null;
        notifyListeners();
      }
    }
  }

  void _onCodeSent(BuildContext context, verificationId, forceResendingToken) async {
    isSendingOTP = false;
    notifyListeners();
    _verificationId = verificationId;
    _forceResendingToken = forceResendingToken;
    _startBounceTimer();
    var isAutoPop = await Navigator.push(context, MaterialPageRoute(builder: (_) => OTPPage()));
    if (isAutoPop != true) resetPage();
  }

  void _verificationCompleted(phoneAuthCredential) {
    isSendingOTP = false;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    bounceTimer?.cancel();
    super.dispose();
  }
}
