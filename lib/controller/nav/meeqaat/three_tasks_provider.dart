import '../../../export.dart';

final meeqaatThreeTasksProvider = ChangeNotifierProvider.autoDispose<MeeqaatThreeTasksNotifier>((ref) => MeeqaatThreeTasksNotifier());

class MeeqaatThreeTasksNotifier extends ChangeNotifier {
  bool isTwoNafiPrayersChecked = false;
  bool isIntentionChecked = false;
  bool isTalbiyahChecked = false;

  bool isLoading = false;

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  updateTwoNafiPrayersChecked() {
    isTwoNafiPrayersChecked = !isTwoNafiPrayersChecked;
    notifyListeners();
  }

  updateIntentionChecked() {
    isIntentionChecked = !isIntentionChecked;
    notifyListeners();
  }

  updateTalbiyahChecked() {
    isTalbiyahChecked = !isTalbiyahChecked;
    notifyListeners();
  }

  void skip() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
    if (result == false || result == null) {
      return;
    }
    isLoading = true;
    if (context.mounted) notifyListeners();
    await ref.read(umraProvider.notifier).updateHasDoneAfterMeeqaatTasks();
    isLoading = false;
    if (context.mounted) notifyListeners();
  }

  void tasksDone() async {
    if (!(isTwoNafiPrayersChecked && isIntentionChecked && isTalbiyahChecked)) {
      errorToast(LocaleKeys.please_check_the_boxes_for_the_two_nafl_prayers_the_intention_and_the_talbiyah.tr());
      return;
    }
    isLoading = true;
    if (context.mounted) notifyListeners();
    await ref.read(umraProvider.notifier).updateHasDoneAfterMeeqaatTasks();
    isLoading = false;
    if (context.mounted) notifyListeners();
  }
}
