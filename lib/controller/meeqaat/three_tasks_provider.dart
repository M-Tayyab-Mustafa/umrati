import '../../export.dart';
import '../../view/nav/page.dart';
import '../../widgets/dialog/confirmation.dart';

final meeqaatThreeTasksProvider = ChangeNotifierProvider<MeeqaatThreeTasksNotifier>((ref) => MeeqaatThreeTasksNotifier());

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
    if (result == false) {
      return;
    }
    LocalStorageManager.showMeeqaatThreeTasksPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }

  void tasksDone(BuildContext context) {
    if (!(isTwoNafiPrayersChecked && isIntentionChecked && isTalbiyahChecked)) {
      errorToast(isLTR(context) ? 'Please check Two Nafi Prayers, Intention and, Talbiyah boxes' : 'براہ کرم دو نفل نماز، نیت، اور تلبیہ کے خانے چیک کریں۔');
      return;
    }
    LocalStorageManager.showMeeqaatThreeTasksPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }
}
