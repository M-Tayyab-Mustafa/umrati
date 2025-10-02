import '../../export.dart';
import '../../view/auth/otp.dart';

final loginProvider = ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  //* Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var phoneNumberUtil = PhoneNumberUtil.instance;
  // bool isSkipping = false;

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void _codeAutoRetrievalTimeout(verificationId) => _verificationId = verificationId;

  //* Login Variables
  bool isSendingOTP = false;
  bool isSocialLogin = false;
  var phoneNumberController = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromDialCode('+92');
  int numberDigits = 10;

  bool isLinkingAccount = false;

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

  resetPage() {
    countDown = _otpTimeOutDuration;
    bounceTimer?.cancel();
    isSendingOTP = false;
    isVerifyingOTP = false;
    isSocialLogin = false;
    otpController.clear();
    notifyListeners();
  }

  //* Skip Login
  // Future<void> skip() async {
  //   try {
  //     var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
  //     if (result == false || result == null) return;
  //     isSkipping = true;
  //     notifyListeners();
  //     var userCredential = await _auth.signInAnonymously().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
  //     UserModel user = UserModel(
  //       uid: userCredential.user!.uid,
  //       name: userCredential.user!.displayName ?? '',
  //       email: userCredential.user!.email ?? '',
  //       photo: userCredential.user!.photoURL ?? '',
  //       phone: '',
  //       country_code: '',
  //       gender: '',
  //     );
  //     await LocalStorageManager.saveUser(user, created_at: FieldValue.serverTimestamp());
  //     isSkipping = false;
  //     notifyListeners();
  //     Navigator.popUntil(context, (route) => route.isFirst);
  //     ref.read(splashProvider).redirections(context);
  //   } catch (e) {
  //     if (kDebugMode) log(e.toString());
  //     errorToast(e.toString());
  //   }
  // }

  //* Send OTP To Phone Number
  Future<void> sendTheOTP([bool isLinkingAccount = false]) async {
    try {
      this.isLinkingAccount = isLinkingAccount;
      final phoneError = simpleFieldValidation(phoneNumberController.text, LocaleKeys.phone_number.tr(), context);
      if (phoneError != null) {
        errorToast(phoneError);
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
            codeSent: _onCodeSent,
            codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
          )
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
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
  void googleLogin() async {
    try {
      isSocialLogin = true;
      notifyListeners();
      await SocialLoginService.instance.signInWithGoogle(context);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    } finally {
      isSocialLogin = false;
      notifyListeners();
    }
  }

  //* Facebook Login
  void facebookLogin() async {
    try {
      isSocialLogin = true;
      notifyListeners();
      await SocialLoginService.instance.signInWithFacebook(context);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    } finally {
      isSocialLogin = false;
      notifyListeners();
    }
  }

  //* Apple Login
  void appleLogin() async {
    try {
      isSocialLogin = true;
      notifyListeners();
      await SocialLoginService.instance.signInWithApple(context);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    } finally {
      isSocialLogin = false;
      notifyListeners();
    }
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
    try {
      _startBounceTimer();
      await _auth
          .verifyPhoneNumber(
            phoneNumber: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!),
            timeout: const Duration(seconds: _otpTimeOutDuration),
            forceResendingToken: _forceResendingToken,
            verificationCompleted: _verificationCompleted,
            verificationFailed: _verificationFailed,
            codeSent: _onCodeSent,
            codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
          )
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  //* OTP Verified
  void verifyOTP() async {
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
          UserModel user = UserModel(
            uid: userCredential.user!.uid,
            phone: userCredential.user!.phoneNumber ?? '',
            country_code: selectedCountry.dialCode ?? '',
            name: '',
            email: '',
            photo: '',
            password: Helper.generateRandomId(),
            gender: '',
          );
          await LocalStorageManager.saveUser(user, created_at: FieldValue.serverTimestamp());
          //* Disable Loading
          isVerifyingOTP = false;
          notifyListeners();
          Navigator.pop(context, true);
          ref.read(splashProvider.notifier).redirections(context);
        } else {
          await LocalStorageManager.saveUser(UserModel.fromMap((await userCollection.doc(userCredential.user!.uid).get()).data()!), toFirebase: false);
          //* Disable Loading
          isVerifyingOTP = false;
          notifyListeners();
          Navigator.pop(context, true);
          ref.read(splashProvider.notifier).redirections(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      isVerifyingOTP = false;
      notifyListeners();
      errorToast(e.message.toString());
    } catch (e) {
      if (kDebugMode) log(e.toString());
      isVerifyingOTP = false;
      notifyListeners();
      errorToast(e.toString());
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
    if (isSendingOTP) {
      _startBounceTimer();
      var isAutoPop = await Navigator.push(context, MaterialPageRoute(builder: (_) => OTPPage()));
      if (isAutoPop != true) resetPage();
    }
  }

  void _verificationCompleted(phoneAuthCredential) {}

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    bounceTimer?.cancel();
    super.dispose();
  }
}
