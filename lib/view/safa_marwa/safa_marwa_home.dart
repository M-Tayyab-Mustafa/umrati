import 'dart:math' show pi;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/safa_marwa/provider.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/card.dart';
import '../../widgets/custom_image.dart';

class SafaMarwaHomePage extends ConsumerStatefulWidget {
  const SafaMarwaHomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SafaMarwaHomePageState();
}

class _SafaMarwaHomePageState extends ConsumerState<SafaMarwaHomePage> {
  late SafaMarwaNotifier notifier;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notifier = ref.watch(safaMarwaProvider);
    notifier.scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (notifier.scrollController!.hasClients) {
        notifier.scrollController!.jumpTo(notifier.scrollController!.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.resetTracking();
      notifier.scrollController?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(safaMarwaProvider);
    provider.context = context;
    return Background(
      showEmblem: false,
      showBottomNav: true,
      backgroundType: BackgroundType.logo,
      logoAlign: MainAxisAlignment.center,
      margin: EdgeInsets.only(top: kToolbarHeight, left: 30, right: 30),
      child: Column(
        children: [
          CButton(
            shadows: [],
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 30),
            onTap: provider.tawafCompletionDialog,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage(path: provider.isTracking ? 'assets/svg/pause.svg' : 'assets/svg/play.svg', imageType: ImageType.svg, height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(provider.isTracking ? LocaleKeys.off_tracker.tr() : LocaleKeys.start_tawaf.tr(), style: CTextStyle.w500(fontSize: 12, color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (provider.circleCount > 0)
                  Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(9999), boxShadow: primaryShadows, color: Colors.white),
                      child: Center(child: Text(provider.circleCount.toString(), style: CTextStyle.w700())),
                    ),
                  ),
                SizedBox(
                  height: screenSize.height,
                  child: SingleChildScrollView(
                    controller: provider.scrollController,
                    child: SizedBox(
                      height: screenSize.height,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImage(path: 'assets/svg/mountain.svg', imageType: ImageType.svg, height: 50),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final centerX = constraints.maxWidth / 2;
                                final lineSpacing = screenSize.width * 0.45;
                                final targetLineX = provider.isOnSideRunComplete ? centerX - lineSpacing / 2 : centerX + lineSpacing / 2;
                                final usableHeight = constraints.maxHeight - 40;
                                return Stack(
                                  children: [
                                    CustomPaint(
                                      size: Size(constraints.maxWidth, constraints.maxHeight),
                                      painter: VerticalDashedAreaPainter(lineSpacing: lineSpacing, dashWidth: 15, dashHeight: 4, lineColor: Colors.black, fillColor: Colors.transparent),
                                    ),

                                    Column(
                                      children: [
                                        Padding(padding: const EdgeInsets.only(top: 10), child: Text(LocaleKeys.marwa.tr(), style: CTextStyle.w800(color: CColors.deepTeal, fontSize: 18))),
                                        const Expanded(child: SizedBox()),
                                        Column(
                                          children: [
                                            Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(LocaleKeys.safa.tr(), style: CTextStyle.w800(color: CColors.deepTeal, fontSize: 18))),
                                            CustomImage(path: 'assets/svg/mountain.svg', imageType: ImageType.svg, height: 50),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Positioned(
                                      left: targetLineX - 20,
                                      top: usableHeight - provider.oneSideRunCompletionPercent * usableHeight,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(shape: BoxShape.circle, gradient: CColors.solidButtonGradient, boxShadow: primaryShadows),
                                        child: Padding(
                                          padding: EdgeInsets.only(top: provider.isOnSideRunComplete ? 4 : 0, bottom: provider.isOnSideRunComplete ? 0 : 4),
                                          child: Transform.rotate(
                                            angle: provider.isOnSideRunComplete ? (pi / 2) : (3 * pi / 2),
                                            child: CustomImage(path: 'assets/svg/play.svg', imageType: ImageType.svg, height: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          Padding(padding: const EdgeInsets.only(bottom: 20, top: 10), child: Text(LocaleKeys.starting_point.tr(), style: CTextStyle.w400(color: CColors.deepTeal, fontSize: 18))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LocaleKeys.dua_during_2nd_round.tr(), style: CTextStyle.w600(fontSize: 20, color: CColors.deepTeal)),
              BasicCard(
                margin: EdgeInsets.only(top: 16, bottom: 25),
                backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
                child: Text(LocaleKeys.round_second_dua.tr(), style: CTextStyle.w500(fontSize: 20, color: CColors.deepTeal), textAlign: TextAlign.center, textDirection: TextDirection.rtl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VerticalDashedAreaPainter extends CustomPainter {
  final double lineSpacing; // Horizontal distance between the lines
  final double dashWidth; // Thickness of each dash
  final double dashHeight; // Vertical length of each dash segment
  final Color lineColor; // Color of the dashes
  final Color fillColor; // Color of the area between the lines

  VerticalDashedAreaPainter({required this.lineSpacing, required this.dashWidth, required this.dashHeight, this.lineColor = Colors.black, this.fillColor = const Color(0x220000FF)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = dashWidth
          ..style = PaintingStyle.stroke;

    final fillPaint =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final leftX = centerX - lineSpacing / 2;
    final rightX = centerX + lineSpacing / 2;

    // Draw the filled area between the lines
    final fillRect = Rect.fromLTRB(leftX, 0, rightX, size.height);
    canvas.drawRect(fillRect, fillPaint);

    // Function to draw a single vertical dashed line
    void drawVerticalDashedLine(double x) {
      double y = 0;
      while (y < size.height) {
        canvas.drawLine(Offset(x, y), Offset(x, y + dashHeight), paint);
        y += dashHeight * 2; // dash + gap
      }
    }

    drawVerticalDashedLine(leftX); // Left line
    drawVerticalDashedLine(rightX); // Right line
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
