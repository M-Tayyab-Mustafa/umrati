import '../../export.dart';

final genderProvider = ChangeNotifierProvider.autoDispose<GenderNotifier>((ref) => GenderNotifier());

class GenderNotifier extends ChangeNotifier {
  Gender selectedGender = Gender.male;
  bool isUpdatingGender = false;

  void updateGender(Gender gender) {
    if (selectedGender == gender) return;
    selectedGender = gender;
    notifyListeners();
  }

  void skip(BuildContext context, WidgetRef ref) async {
    try {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.confirmation_dialog.tr()));
      if (result == false || result == null) {
        return;
      }
      isUpdatingGender = true;
      notifyListeners();
      var user = (await LocalStorageManager.getUser())!.copyWith(gender: Gender.male.name.toLowerCase());
      await LocalStorageManager.saveUser(user).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
    } catch (e) {
      isUpdatingGender = false;
      notifyListeners();
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }

  void continueTap(BuildContext context, WidgetRef ref) async {
    try {
      isUpdatingGender = true;
      notifyListeners();
      var user = (await LocalStorageManager.getUser())!.copyWith(gender: selectedGender.name.toLowerCase());
      await LocalStorageManager.saveUser(user).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
    } catch (e) {
      isUpdatingGender = false;
      notifyListeners();
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }
}
