import '../../export.dart';

final emailOrPhoneLinkingProvider = ChangeNotifierProvider.autoDispose<EmailOrPhoneLinkingNotifier>((ref) => EmailOrPhoneLinkingNotifier());

class EmailOrPhoneLinkingNotifier extends ChangeNotifier {
  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  Gender selectedGender = Gender.unknown;
  bool isUpdatingGender = false;
  UserModel? user;
  var phoneNumberUtil = PhoneNumberUtil.instance;
  CountryCode selectedCountry = CountryCode.fromDialCode('+92');
  int numberDigits = 10;
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  bool isOTPSent = false;

  bool isLinkingAccount = false;

  void initialization() async {
    user = await LocalStorageManager.getUser(fromFirebase: true);
    notifyListeners();
  }

  void linkAccount() async {
    if ((user?.email ?? '').isEmpty) {
      if (emailController.text.isEmpty) {
        errorToast(LocaleKeys.please_enter_your_email.tr());
        return;
      }
      isLinkingAccount = true;
      notifyListeners();
      try {
        final credential = EmailAuthProvider.credential(email: emailController.text.trim(), password: user!.password);
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        await LocalStorageManager.saveUser(user!.copyWith(email: emailController.text.trim()));
        infoToast(LocaleKeys.account_linked_successfully.tr());
        ref.read(splashProvider.notifier).redirections(context);
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) log(e.toString());
        errorToast(e.message ?? LocaleKeys.something_went_wrong_please_try_again_later.tr());
      } catch (e) {
        if (kDebugMode) log(e.toString());
        errorToast(e.toString());
      }
      isLinkingAccount = false;
      notifyListeners();
    } else {
      isLinkingAccount = true;
      notifyListeners();
      try {
        final provider = ref.read(loginProvider.notifier);
        provider.context = context;
        provider.ref = ref;
        provider.phoneNumberController.text = phoneNumberController.text.trim();
        provider.selectedCountry = selectedCountry;
        provider.numberDigits = numberDigits;
        await provider.sendTheOTP(true);
      } catch (e) {
        if (kDebugMode) log(e.toString());
        errorToast(e.toString());
      }
      isLinkingAccount = false;
      notifyListeners();
    }
  }

  //* OTP Time Out Duration
  static const int _otpTimeOutDuration = 90;
  int _countDown = _otpTimeOutDuration;
  int get countDown => _countDown;

  bool isLoading = false;
  set countDown(int value) {
    _countDown = value;
    notifyListeners();
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
}
