import '../../export.dart';

final phoneProvider = ChangeNotifierProvider.autoDispose<PhoneNotifier>((ref) => PhoneNotifier());

class PhoneNotifier extends ChangeNotifier {
  //* Instances
  var phoneNumberUtil = PhoneNumberUtil.instance;

  //* Phone No Variables
  var phoneNumberController = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromDialCode('+92');
  int numberDigits = 10;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

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

  Future<void> continueTap() async {
    try {
      isLoading = true;
      notifyListeners();
      var user = await LocalStorageManager.getUser(fromFirebase: true);
      user = user?.copyWith(country_code: selectedCountry.dialCode, phone: Helper.formatePhoneNumber(phoneNumberController.text, selectedCountry.dialCode!));
      await LocalStorageManager.saveUser(user!).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      Navigator.popUntil(context, (route) => route.isFirst);
      ref.read(splashProvider.notifier).redirections(context);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }
}
