import '../../export.dart';

final emailOrPhoneLinkingProvider = ChangeNotifierProvider<EmailOrPhoneLinkingNotifier>((ref) => EmailOrPhoneLinkingNotifier());

class EmailOrPhoneLinkingNotifier extends ChangeNotifier {
  Gender selectedGender = Gender.male;
  bool isUpdatingGender = false;
  UserModel? user;
  var phoneNumberUtil = PhoneNumberUtil.instance;
  CountryCode selectedCountry = CountryCode.fromDialCode('+92');
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  bool isOTPSent = false;

  bool isLinkingAccount = false;

  void initialization() async {
    user = await LocalStorageManager.getUser(fromFirebase: true);
    notifyListeners();
  }

  void linkAccount(BuildContext context, WidgetRef ref) async {
    if ((user?.email ?? '').isEmpty) {
      if (emailController.text.isEmpty) {
        errorToast(LocaleKeys.please_enter_your_email.tr());
        return;
      }
      try {
        isLinkingAccount = true;
        notifyListeners();
        final credential = EmailAuthProvider.credential(email: emailController.text.trim(), password: user!.password);
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        await LocalStorageManager.saveUser(user!.copyWith(email: emailController.text.trim()));
        infoToast(LocaleKeys.account_linked_successfully.tr());
        ref.read(splashProvider.notifier).redirections(context);
      } on FirebaseAuthException catch (e) {
        appLog(e.toString());
        errorToast(e.message ?? LocaleKeys.something_went_wrong_please_try_again_later.tr());
        isLinkingAccount = false;
        notifyListeners();
      } catch (e) {
        appLog(e.toString());
        errorToast(LocaleKeys.some_thing_went_wrong.tr());
        isLinkingAccount = false;
        notifyListeners();
      }
    } else {
      isLinkingAccount = true;
      notifyListeners();
      try {
        final provider = ref.read(loginProvider.notifier);
        provider.phoneNumberController.text = phoneNumberController.text.trim();
        provider.selectedCountry = selectedCountry;
        await provider.sendTheOTP(context, true);
      } catch (e) {
        appLog(e.toString());
        errorToast(LocaleKeys.some_thing_went_wrong.tr());
        isLinkingAccount = false;
        notifyListeners();
      }
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
    notifyListeners();
  }
}
