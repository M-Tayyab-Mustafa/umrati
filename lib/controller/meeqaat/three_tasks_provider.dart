import '../../export.dart';
import '../../view/nav/page.dart';

final meeqaatThreeTasksProvider = ChangeNotifierProvider.autoDispose<MeeqaatThreeTasksNotifier>((ref) => MeeqaatThreeTasksNotifier());

class MeeqaatThreeTasksNotifier extends ChangeNotifier {
  bool isTwoNafiPrayersChecked = false;
  bool isIntentionChecked = false;
  bool isTalbiyahChecked = false;

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

  void skip(BuildContext context) async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
    if (result == false || result == null) {
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }

  void tasksDone(BuildContext context) {
    if (!(isTwoNafiPrayersChecked && isIntentionChecked && isTalbiyahChecked)) {
      errorToast(LocaleKeys.please_check_the_boxes_for_the_two_nafl_prayers_the_intention_and_the_talbiyah.tr());
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }
}
