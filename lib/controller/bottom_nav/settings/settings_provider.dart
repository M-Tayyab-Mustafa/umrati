import '../../../export.dart';
import '../../../view/bottom_nav/settings/give_feedback.dart';
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

  Future<void> onGiveFeedbackTap() async => await Navigator.push(context, MaterialPageRoute(builder: (context) => const GiveFeedbackPage()));

  Future<void> onBuyPremiumTap() async => await Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage(isRenewingPlan: true)));

  void onChangeTheThemeTap() async {}
}
