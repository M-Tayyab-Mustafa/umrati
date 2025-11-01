import '../../../../export.dart';

class SafaMarwaPage extends ConsumerStatefulWidget {
  const SafaMarwaPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SafaMarwaHomePageState();
}

class _SafaMarwaHomePageState extends ConsumerState<SafaMarwaPage> {
  @override
  void initState() {
    super.initState();
    final provider = ref.read(safaMarwaProvider.notifier);
    provider.context = context;
    provider.ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.initialization();
      if (provider.scrollController.hasClients) {
        provider.scrollController.jumpTo(provider.scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(safaMarwaProvider);
    var uProvider = ref.watch(umrahProvider);
    var safaMarwaDistance = SizeConfig.h(SizeConfig.screenHeight);
    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logoWithSkip,
      onSkipTap: provider.debugSkipSafaMarwa,
      titleMargin: SizeConfig.only(top: kToolbarHeight * 0.5, left: 16, right: 16),
      titleType: TitleType.backArrow,
      titleWidget: Center(
        child: Visibility(
          visible: provider.saiRoundCount != 7,
          child: CButton(
            height: 45,
            margin: SizeConfig.only(right: isLTR(context) ? 40 : 0, left: isLTR(context) ? 0 : 40),
            onTap: ref.read(umrahProvider.notifier).pauseAndResumeTracker,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(path: !uProvider.isTrackerPaused ? 'assets/svg/pause.svg' : 'assets/svg/play.svg', imageType: ImageType.svg, height: SizeConfig.h(16)),
                  Padding(
                    padding: SizeConfig.only(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8),
                    child: Text(!uProvider.isTrackerPaused ? LocaleKeys.pause_tracker.tr() : LocaleKeys.start_tracker.tr(), style: CTextStyle.w500(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      showEmblem: false,
      margin: SizeConfig.only(top: kToolbarHeight * 0.5, bottom: kToolbarHeight * 0.5),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: provider.scrollController,
                    child: Padding(
                      padding: SizeConfig.symmetric(vertical: 16),
                      child: SizedBox(
                        height: safaMarwaDistance,
                        width: SizeConfig.screenWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImage(path: 'assets/svg/mountain.svg', imageType: ImageType.svg, height: SizeConfig.w(50)),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final trackWidth = SizeConfig.w(250);
                                  final trackerSize = SizeConfig.h(40);
                                  return Stack(
                                    children: [
                                      Center(
                                        child: CustomPaint(
                                          size: Size(trackWidth, safaMarwaDistance),
                                          painter: _VerticalDashedAreaPainter(lineSpacing: trackWidth - SizeConfig.w(15), dashWidth: SizeConfig.w(15), dashHeight: SizeConfig.h(4), lineColor: Colors.black, fillColor: Colors.transparent),
                                        ),
                                      ),
                                      Align(alignment: Alignment.bottomCenter, child: _AreaToRunFast(width: trackWidth, height: safaMarwaDistance, provider: provider)),
                                      Column(
                                        children: [
                                          Padding(padding: SizeConfig.only(top: 8), child: Text(LocaleKeys.marwa.tr(), style: CTextStyle.w800(color: CColors.deepTeal, fontSize: 20))),
                                          Spacer(),
                                          Column(
                                            children: [
                                              Padding(padding: SizeConfig.only(bottom: 8), child: Text(LocaleKeys.safa.tr(), style: CTextStyle.w800(color: CColors.deepTeal, fontSize: 20))),
                                              CustomImage(path: 'assets/svg/mountain.svg', imageType: ImageType.svg, height: SizeConfig.w(50)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      AnimatedAlign(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        alignment: Alignment(provider.isOneSideSaiRunCompleted ? -0.67 : 0.67, (1 - 2 * provider.oneSideRunCompletionPercent).clamp(-1.0, 1.0)),
                                        child: Container(
                                          width: trackerSize,
                                          height: trackerSize,
                                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: CColors.solidButtonGradient, boxShadow: primaryShadows),
                                          child: Padding(
                                            padding: SizeConfig.only(top: provider.isOneSideSaiRunCompleted ? 4 : 0, bottom: provider.isOneSideSaiRunCompleted ? 0 : 4),
                                            child: Transform.rotate(angle: provider.isOneSideSaiRunCompleted ? (pi / 2) : (3 * pi / 2), child: CustomImage(path: 'assets/svg/play.svg', imageType: ImageType.svg, height: SizeConfig.w(20))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(padding: SizeConfig.only(top: 10), child: Text(LocaleKeys.starting_point.tr(), style: CTextStyle.w400(color: CColors.deepTeal))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (provider.saiRoundCount > 0)
                    Align(
                      alignment: Alignment(0, 0.1),
                      child: Container(
                        height: SizeConfig.w(40),
                        width: SizeConfig.w(40),
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: primaryShadows, color: Colors.white),
                        child: Center(child: Text(provider.saiRoundCount.toString(), style: CTextStyle.w900(fontSize: 20, color: CColors.primary))),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildDuaWidget(context: context, provider: provider),
        ],
      ),
    );
  }

  _buildDuaWidget({required BuildContext context, required SafaMarwaNotifier provider}) {
    String duaTitle = switch (provider.saiRoundCount) {
      0 => LocaleKeys.dua_during_1st_round.tr(),
      1 => LocaleKeys.dua_during_2nd_round.tr(),
      2 => LocaleKeys.dua_during_3rd_round.tr(),
      3 => LocaleKeys.dua_during_4th_round.tr(),
      4 => LocaleKeys.dua_during_5th_round.tr(),
      5 => LocaleKeys.dua_during_6th_round.tr(),
      _ => LocaleKeys.dua_during_7th_round.tr(),
    };
    String dua = switch (provider.saiRoundCount) {
      0 => Dua.round1.dua,
      1 => Dua.round2.dua,
      2 => Dua.round3.dua,
      3 => Dua.round4.dua,
      4 => Dua.round5.dua,
      5 => Dua.round6.dua,
      _ => LocaleKeys.ask_legitimate_needs.tr(),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$duaTitle${ref.read(umrahProvider.notifier).user?.gender == Gender.female.name ? ' (${LocaleKeys.in_low_voice.tr()})' : ''}', style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal)),
        BasicCard(
          margin: SizeConfig.symmetric(vertical: 8, horizontal: 16),
          backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
          child: Center(child: Text(dua, style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal, fontFamily: provider.saiRoundCount < 6 ? Helper.arabicTextFontFamily : null), textAlign: TextAlign.center, textDirection: TextDirection.rtl)),
        ),
      ],
    );
  }
}

class _VerticalDashedAreaPainter extends CustomPainter {
  final double lineSpacing;
  final double dashWidth;
  final double dashHeight;
  final Color lineColor;
  final Color fillColor;

  _VerticalDashedAreaPainter({required this.lineSpacing, required this.dashWidth, required this.dashHeight, this.lineColor = Colors.black, this.fillColor = const Color(0x220000FF)});

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

    final centerX = size.width * 0.5;
    final leftX = centerX - (lineSpacing * 0.5);
    final rightX = centerX + (lineSpacing * 0.5);

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

class _AreaToRunFast extends StatelessWidget {
  const _AreaToRunFast({required this.width, required this.height, required this.provider});
  final double width;
  final double height;
  final SafaMarwaNotifier provider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: EdgeInsets.only(bottom: height * 0.29, top: height * 0.50),
        child: Stack(
          children: [
            Container(color: CColors.primary.withValues(alpha: 0.15), margin: SizeConfig.symmetric(horizontal: 10)),
            Align(alignment: Alignment.centerLeft, child: Container(color: CColors.secondary, width: SizeConfig.w(20))),
            Align(alignment: Alignment.centerRight, child: Container(color: CColors.secondary, width: SizeConfig.w(20))),
            Center(child: Text(LocaleKeys.area_to_run_fast.tr(), style: CTextStyle.w300(color: Colors.white, fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
