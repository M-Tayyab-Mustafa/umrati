// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../export.dart';
import '../../view/auth/login.dart';
import '../../view/language/language.dart';

final selectLanguageProvider = ChangeNotifierProvider.autoDispose<SelectLanguageNotifier>((ref) => SelectLanguageNotifier());

class SelectLanguageNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  String selectedLanguage = LocaleKeys.english;

  Future<void> initialization() async {
    selectedLanguage = context.locale.languageCode == 'en' ? LocaleKeys.english : LocaleKeys.urdu;
    notifyListeners();
  }

  Future<void> changeLanguageTap() async {
    ref.read(languageProvider).resetLanguage(context);
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
    if (result != null) {
      selectedLanguage = result;
      notifyListeners();
    }
  }

  Future<void> continueTap() async {
    LocalStorageManager.showSelectLanguagePage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
