import '../../../export.dart';
import '../../../view/bottom_nav/settings/history/tawaf.dart';
import '../../../view/bottom_nav/settings/history/umrah.dart';

final historyProvider = ChangeNotifierProvider.autoDispose<HistoryNotifier>((ref) => HistoryNotifier());

class HistoryNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;
  UserModel? user;
  bool isLoading = true;

  Map<DateTime, List<HistoryModel>> umrahHistories = {};
  Map<DateTime, List<HistoryModel>> tawafHistories = {};

  Future<void> initialization({bool fromUmrah = true}) async {
    isLoading = true;
    notifyListeners();
    user = await LocalStorageManager.getUser(fromFirebase: true);
    if (fromUmrah) {
      final umras =
          (await historyCollection.where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UmraType.umra.name))).get()).docs
              .map((history) => HistoryModel.fromMap(history.data()))
              .toList();
      umrahHistories = groupBy(umras, (history) {
        var time = history.created_at!.toDate();
        return DateTime(time.year, time.month, time.day);
      });
    } else {
      final tawaf =
          (await historyCollection.where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UmraType.tawaf.name))).get()).docs
              .map((history) => HistoryModel.fromMap(history.data()))
              .toList();
      tawafHistories = groupBy(tawaf, (history) {
        var time = history.created_at!.toDate();
        return DateTime(time.year, time.month, time.day);
      });
    }

    isLoading = false;
    notifyListeners();
  }

  void onUmraTap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const UmrahHistoryPage()));

  void onTawafTap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const TawafHistoryPage()));

  void onZiaratTap() {}
}
