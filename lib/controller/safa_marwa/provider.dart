import 'dart:async' show Timer;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../view/complete_tawaf.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_image.dart';

final safaMarwaProvider = ChangeNotifierProvider<SafaMarwaNotifier>((ref) => SafaMarwaNotifier());

class SafaMarwaNotifier extends ChangeNotifier {
  BuildContext? context;
  ScrollController? scrollController;
  bool isTracking = true;
  double oneSideRunCompletionPercent = 0.0;
  bool isOnSideRunComplete = false;
  int circleCount = -1;
  Timer? timer;
  startTawaf() {
    if (isTracking) {
      resetTracking();
      return;
    }
    isTracking = true;
    notifyListeners();
    updateLocation();
  }

  void updateLocation() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      if (isOnSideRunComplete) {
        if (oneSideRunCompletionPercent <= 0.0000) {
          _updateCircleCount();
        } else {
          oneSideRunCompletionPercent = roundToOneDecimal(oneSideRunCompletionPercent - 0.1);
        }
      } else {
        if (oneSideRunCompletionPercent >= 1.0000) {
          isOnSideRunComplete = true;
        } else {
          oneSideRunCompletionPercent = roundToOneDecimal(oneSideRunCompletionPercent + 0.1);
        }
      }
      notifyListeners();
      if (scrollController!.hasClients) {
        var position = scrollController!.position.maxScrollExtent * (1 - oneSideRunCompletionPercent);
        scrollController!.animateTo(position, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      }
    });
  }

  resetTracking() {
    circleCount = -1;
    oneSideRunCompletionPercent = 0;
    timer?.cancel();
    notifyListeners();
  }

  _updateCircleCount() {
    timer?.cancel();
    circleCount == -1 ? circleCount = 1 : circleCount++;
    if (circleCount == 7) {
      tawafCompletionDialog();
    }
    isOnSideRunComplete = false;
  }

  tawafCompletionDialog() async {
    await showGeneralDialog(context: context!, pageBuilder: (context, animation, secondaryAnimation) => TawafCompletionDialog());
  }
}

class TawafCompletionDialog extends StatefulWidget {
  const TawafCompletionDialog({super.key});

  @override
  State<TawafCompletionDialog> createState() => _TawafCompletionDialogState();
}

class _TawafCompletionDialogState extends State<TawafCompletionDialog> {
  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: screenSize.width * 0.67,
              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.0),
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                          child: Text(LocaleKeys.now_please_pray_while_facing_kibla.tr(), style: CTextStyle.w900(fontSize: 20, color: CColors.deepTeal), textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                  CButton(
                    title: 'Continue',
                    titleWithIcon: true,
                    onTap: () {
                      Navigator.popUntil(dialogContext, (route) => route.isFirst);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SaiCompletionPage()));
                    },
                    margin: EdgeInsets.only(bottom: 30),
                  ),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment(0, -0.3), child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80)),
        ],
      ),
    );
  }
}
