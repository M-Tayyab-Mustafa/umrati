import '../../../export.dart';
import '../../../view/bottom_nav/settings/history/tawaf.dart';
import '../../../view/bottom_nav/settings/history/umrah.dart';
import '../../../view/bottom_nav/settings/history/ziaraat.dart';
import '../../../view/bottom_nav/settings/history/ziaraat_detail.dart';

final historyProvider = ChangeNotifierProvider.autoDispose<HistoryNotifier>((ref) => HistoryNotifier());

class HistoryNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;
  bool isLoading = true;
  UserModel? user;

  Map<DateTime, List<HistoryModel>> umrahHistories = {};
  Map<DateTime, List<HistoryModel>> tawafHistories = {};
  List<ZiaraatHistoryModel> ziaraatHistories = [];

  Future<void> initialization({HistoryType historyType = HistoryType.umrah}) async {
    isLoading = true;
    notifyListeners();
    user = await LocalStorageManager.getUser();
    if (historyType == HistoryType.umrah) {
      final query =
          (await historyCollection.where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UserActivityType.umrah.name))).get()).docs
              .map((history) => HistoryModel.fromMap(history.data()))
              .toList();
      umrahHistories = groupBy(query, (history) {
        var time = history.created_at!.toDate();
        return DateTime(time.year, time.month, time.day);
      });
    } else if (historyType == HistoryType.tawaf) {
      final query =
          (await historyCollection.where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UserActivityType.tawaf.name))).get()).docs
              .map((history) => HistoryModel.fromMap(history.data()))
              .toList();
      tawafHistories = groupBy(query, (history) {
        var time = history.created_at!.toDate();
        return DateTime(time.year, time.month, time.day);
      });
    } else {
      var query = await historyCollection
          .where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UserActivityType.ziaraat.name)))
          .get()
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      ziaraatHistories = query.docs.map((history) => ZiaraatHistoryModel.fromMap(history.data())).toList();
    }
    isLoading = false;
    notifyListeners();
  }

  void onUmrahTap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const UmrahHistoryPage()));

  void onTawafTap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const TawafHistoryPage()));

  void onZiaraatTap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const ZiaraatHistoryPage()));

  void onViewZiaraatTap(ZiaraatHistoryModel history) => Navigator.push(context, MaterialPageRoute(builder: (context) => ZiaraatDetailPage(ziaraatHistory: history)));
}
