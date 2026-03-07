import '../../../../export.dart';

final meeqaatTwoTasksProvider = ChangeNotifierProvider.autoDispose<MeeqaatTwoTasksNotifier>((ref) => MeeqaatTwoTasksNotifier());

class MeeqaatTwoTasksNotifier extends ChangeNotifier {
  bool isCleanlinessChecked = false;
  bool isIhramChecked = false;
  UserModel? user;

  bool isLoading = true;

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  Future<void> initialization() async {
    user = await LocalStorageManager.getUser(fromFirebase: true);
    isLoading = false;
    if (context.mounted) notifyListeners();
  }

  void skip() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.confirmation_dialog.tr()));
    if (result == false || result == null) {
      return;
    }
    isLoading = true;
    if (context.mounted) notifyListeners();
    await ref.read(umrahProvider.notifier).updateHasDoneBeforeMeeqaatTasks();
    isLoading = false;
    if (context.mounted) notifyListeners();
  }

  void moveToThreeOtherTasks() async {
    if (!(isCleanlinessChecked && isIhramChecked)) {
      errorToast(LocaleKeys.please_check_the_cleanliness_and_ihram_boxes.tr());
      return;
    }
    isLoading = true;
    if (context.mounted) notifyListeners();
    await ref.read(umrahProvider.notifier).updateHasDoneBeforeMeeqaatTasks();
    isLoading = false;
    if (context.mounted) notifyListeners();
  }

  void showIhramTutorial() async {
    if (user == null) return;
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => IhramTutorialDialog(gender: user!.gender));
    if (result == true) {
      isIhramChecked = true;
      notifyListeners();
    }
  }

  void updateCleanlinessChecked() {
    isCleanlinessChecked = !isCleanlinessChecked;
    notifyListeners();
  }

  void updateIhramChecked() {
    isIhramChecked = !isIhramChecked;
    notifyListeners();
  }

  void updateLoading(bool bool) {
    isLoading = bool;
    notifyListeners();
  }
}

class IhramTutorialDialog extends StatelessWidget {
  const IhramTutorialDialog({super.key, required this.gender});
  final String gender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: CColors.shadow.withValues(alpha: 0.2),
        body: Center(
          child: Stack(
            children: [
              Center(child: Container(decoration: BoxDecoration(color: Colors.black38))),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder:
                          (context, ref, child) => CCheckBox(
                            onTap: ref.read(meeqaatTwoTasksProvider).updateIhramChecked,
                            value: ref.watch(meeqaatTwoTasksProvider).isIhramChecked,
                            size: 25,
                            activeColor: Colors.transparent,
                            borderColor: Colors.white,
                            borderRadius: 10,
                            borderWidth: 2.5,
                          ),
                    ),
                    Container(
                      margin: context.edgeInsets(top: screenSize.height * 0.07),
                      padding: context.edgeInsets(top: 20, bottom: 20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: CColors.primary, width: 2), boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList()),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (gender == Gender.female.name) Padding(padding: context.edgeInsets(bottom: 20), child: Text(LocaleKeys.no_face_veil_or_gloves.tr(), style: CTextStyle.w600(color: CColors.primary))),
                          CustomImage(
                            path: gender == Gender.male.name ? 'assets/png/ihram_tutorial.png' : 'assets/png/abaya_tutorial.png',
                            imageType: ImageType.png,
                            enableBorder: true,
                            height: 500,
                            width: screenSize.width * 0.85,
                            borderRadius: BorderRadius.circular(20),
                            fit: BoxFit.scaleDown,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
