import '../../../export.dart';

final giveFeedbackProvider = ChangeNotifierProvider.autoDispose<GiveFeedbackNotifier>((ref) => GiveFeedbackNotifier());

class GiveFeedbackNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;
  bool isLoading = true;

  UserModel? user;
  CountryCode selectedCountry = CountryCode.fromDialCode('+92');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  Future<void> initialization() async {
    isLoading = true;
    notifyListeners();
    user = await LocalStorageManager.getUser(fromFirebase: true);
    emailController.text = user!.email;
    numberController.text = user!.phone.contains(user!.country_code) ? user!.phone.replaceAll(user!.country_code, '') : user!.phone;
    isLoading = false;
    notifyListeners();
  }

  void submit() {}

  //* Update Selected Country Code
  void updateSelectedCountry(CountryCode selectedCountry) async {
    this.selectedCountry = selectedCountry;
    notifyListeners();
  }
}
