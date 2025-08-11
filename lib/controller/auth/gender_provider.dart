import '../../export.dart';
import '../../view/meeqaat/two_tasks.dart';
import '../../widgets/dialog/confirmation.dart';

final genderProvider = ChangeNotifierProvider.autoDispose<GenderNotifier>((ref) => GenderNotifier());

class GenderNotifier extends ChangeNotifier {
  Gender selectedGender = Gender.unknown;
  bool isUpdatingGender = false;
  void updateGender(Gender gender) {
    if (selectedGender == gender) return;
    selectedGender = gender;
    notifyListeners();
  }

  void skip(BuildContext context) async {
    try {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
      if (result == false) {
        return;
      }
      isUpdatingGender = true;
      notifyListeners();
      await LocalStorageManager.showGenderPage(false);
      var user = (await LocalStorageManager.getUser())!.copyWith(gender: Gender.unknown.name.toLowerCase());
      await LocalStorageManager.saveUser(user).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      isUpdatingGender = false;
      notifyListeners();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
    } catch (e) {
      errorToast(e.toString());
    }
  }

  void continueTap(BuildContext context) async {
    try {
      isUpdatingGender = true;
      notifyListeners();
      var user = (await LocalStorageManager.getUser())!.copyWith(gender: selectedGender.name.toLowerCase());
      await LocalStorageManager.saveUser(user).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      await LocalStorageManager.showGenderPage(false);
      isUpdatingGender = false;
      notifyListeners();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatTwoTasksPage()));
    } catch (e) {
      errorToast(e.toString());
    }
  }
}
