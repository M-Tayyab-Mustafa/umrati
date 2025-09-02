import '../../export.dart';

final genderProvider = ChangeNotifierProvider.autoDispose<GenderNotifier>((ref) => GenderNotifier());

class GenderNotifier extends ChangeNotifier {
  Gender selectedGender = Gender.unknown;
  bool isUpdatingGender = false;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void updateGender(Gender gender) {
    if (selectedGender == gender) return;
    selectedGender = gender;
    notifyListeners();
  }

  void skip(BuildContext context) async {
    try {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
      if (result == false || result == null) {
        return;
      }
      isUpdatingGender = true;
      notifyListeners();
      var user = (await LocalStorageManager.getUser())!.copyWith(gender: Gender.unknown.name.toLowerCase());
      await LocalStorageManager.saveUser(user).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      isUpdatingGender = false;
      notifyListeners();
      ref.read(splashProvider.notifier).redirections(context, false);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  void continueTap(BuildContext context) async {
    try {
      isUpdatingGender = true;
      notifyListeners();
      var user = (await LocalStorageManager.getUser())!.copyWith(gender: selectedGender.name.toLowerCase());
      await LocalStorageManager.saveUser(user).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      isUpdatingGender = false;
      notifyListeners();
      ref.read(splashProvider.notifier).redirections(context, false);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }
}
