import '../../../export.dart';

final meeqaatTwoTasksProvider = ChangeNotifierProvider.autoDispose<MeeqaatTwoTasksNotifier>((ref) => MeeqaatTwoTasksNotifier());

class MeeqaatTwoTasksNotifier extends ChangeNotifier {
  bool isCleanlinessChecked = false;
  bool isIhramChecked = false;

  bool isLoading = false;

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void skip() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
    if (result == false || result == null) {
      return;
    }
    isLoading = true;
    if (context.mounted) notifyListeners();
    await ref.read(umraProvider.notifier).updateHasDoneBeforeMeeqaatTasks();
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
    await ref.read(umraProvider.notifier).updateHasDoneBeforeMeeqaatTasks();
    isLoading = false;
    if (context.mounted) notifyListeners();
  }

  void showIhramTutorial() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => IhramTutorialDialog());
    if (result == true) {
      isIhramChecked = true;
      notifyListeners();
    }
  }

  updateCleanlinessChecked() {
    isCleanlinessChecked = !isCleanlinessChecked;
    notifyListeners();
  }

  updateIhramChecked() {
    isIhramChecked = !isIhramChecked;
    notifyListeners();
  }

  void updateLoading(bool bool) {
    isLoading = bool;
    notifyListeners();
  }
}

class IhramTutorialDialog extends StatelessWidget {
  const IhramTutorialDialog({super.key});

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
                      margin: EdgeInsets.only(top: screenSize.height * 0.07),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: CColors.primary, width: 2),
                        boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
                      ),
                      child: CustomImage(
                        path: 'assets/png/ihram_tutorial.png',
                        imageType: ImageType.png,
                        enableBorder: true,
                        height: 500,
                        width: screenSize.width * 0.85,
                        borderRadius: BorderRadius.circular(20),
                        fit: BoxFit.fill,
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
