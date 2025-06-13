import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/utils/services/toast.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/local_storage.dart';
import '../../utils/theme/colors.dart';
import '../../view/permission.dart';
import '../../view/nav/page.dart';
import '../../widgets/check_box.dart';
import '../../widgets/custom_image.dart';

final meeqaatTwoTasksProvider = ChangeNotifierProvider<MeeqaatTwoTasksNotifier>((ref) => MeeqaatTwoTasksNotifier());

class MeeqaatTwoTasksNotifier extends ChangeNotifier {
  bool isCleanlinessChecked = false;
  bool isIhramChecked = false;
  bool isSkipLoading = false;

  void skip(BuildContext context) {
    isSkipLoading = true;
    notifyListeners();
    LocalStorageManager.showTwoTasksBeforeMeeqaatPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }

  void moveToThreeOtherTasks(BuildContext context) {
    if (!(isCleanlinessChecked && isIhramChecked)) {
      errorToast(isLTR(context) ? 'Please check cleanliness and ihram boxes' : 'براہ کرم پاکیزگی اور احرام کے خانے چیک کریں۔');
      return;
    }
    LocalStorageManager.showTwoTasksBeforeMeeqaatPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LocationPermissionPage()));
  }

  void showIhramTutorial(BuildContext context) async {
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
