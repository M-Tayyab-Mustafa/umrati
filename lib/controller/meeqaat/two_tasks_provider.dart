import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/helper/constants.dart';
import '../../utils/theme/colors.dart';
import '../../view/meeqaat/permission.dart';
import '../../widgets/check_box.dart';
import '../../widgets/custom_image.dart';

final meeqaatTwoTasksProvider = ChangeNotifierProvider<MeeqaatTwoTasksNotifier>((ref) => MeeqaatTwoTasksNotifier());

class MeeqaatTwoTasksNotifier extends ChangeNotifier {
  bool isConfirmingMeeqaat = false;
  bool isCleanlinessChecked = false;
  bool isIhramChecked = false;

  void skip(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatPermissionPage()));
  }

  void moveToThreeOtherTasks(BuildContext context) {
    isConfirmingMeeqaat = true;
    notifyListeners();
    isConfirmingMeeqaat = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatPermissionPage()));
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
