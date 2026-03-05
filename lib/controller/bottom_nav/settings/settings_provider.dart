import '../../../export.dart';
import '../../../view/bottom_nav/settings/history/page.dart';
import '../../../view/language/language.dart';
import '../../../view/subscription/page.dart';

final settingsProvider = ChangeNotifierProvider.autoDispose<SettingsNotifier>((ref) => SettingsNotifier());

class SettingsNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  UserModel? user;

  Future<void> initialization() async {
    user = await LocalStorageManager.getUser();
    notifyListeners();
  }

  Future<void> onHistoryTap() async => await Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));

  Future<void> onChangeTheLanguageTap() async => await Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguagePage(isUpdatingLanguage: true)));

  Future<void> onGiveFeedbackTap() async {
    final String phone = "+923390706666";
    final Uri url = Uri.parse("https://wa.me/$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> onTermsAndConditionsTap() async {
    final Uri url = Uri.parse("https://sites.google.com/view/umrati-umrah-guidance-app/home");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> onBuyPremiumTap() async => await Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage(isRenewingPlan: true)));

  void onChangeTheThemeTap() async {}
}
