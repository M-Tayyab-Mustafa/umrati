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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = ref.read(safaMarwaProvider.notifier);
      await provider.initialization();
      if (provider.scrollController.hasClients) {
        provider.scrollController.jumpTo(provider.scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(safaMarwaProvider);
    ref.read(safaMarwaProvider.notifier).context = context;
    ref.read(safaMarwaProvider.notifier).ref = ref;
    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06, bottom: 85),
      showEmblem: false,
      child: Column(
        children: [
          Visibility(
            visible: provider.saiRoundCount != 7,
            child: CButton(
              shadows: [],
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 30),
              onTap: ref.read(umraProvider.notifier).startAndStopTawaf,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(path: 'assets/svg/pause.svg', imageType: ImageType.svg, height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8),
                    child: Text(LocaleKeys.off_tracker.tr(), style: CTextStyle.w500(fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (provider.saiRoundCount > 0)
                  Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(9999), boxShadow: primaryShadows, color: Colors.white),
                      child: Center(child: Text(provider.saiRoundCount.toString(), style: CTextStyle.w700())),
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
                                final targetLineX = provider.isRunComplete ? centerX - lineSpacing / 2 : centerX + lineSpacing / 2;
                                final usableHeight = constraints.maxHeight - 40;
                                return Stack(
                                  children: [
                                    CustomPaint(
                                      size: Size(constraints.maxWidth, constraints.maxHeight),
                                      painter: _VerticalDashedAreaPainter(lineSpacing: lineSpacing, dashWidth: 15, dashHeight: 4, lineColor: Colors.black, fillColor: Colors.transparent),
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
                                          padding: EdgeInsets.only(top: provider.isRunComplete ? 4 : 0, bottom: provider.isRunComplete ? 0 : 4),
                                          child: Transform.rotate(
                                            angle: provider.isRunComplete ? (pi / 2) : (3 * pi / 2),
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
          _buildDuaWidget(context: context, provider: provider),
        ],
      ),
    );
  }

  _buildDuaWidget({required BuildContext context, required SafaMarwaNotifier provider}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${provider.isRunComplete ? LocaleKeys.going_to_safa.tr() : LocaleKeys.going_to_marwa.tr()}${ref.read(umraProvider.notifier).user?.gender == Gender.female.name ? ' (${LocaleKeys.in_low_voice.tr()})' : ''}',
          style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal),
        ),
        BasicCard(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
          child: Text(
            provider.isRunComplete ? Dua.goingToSafa.dua : Dua.goingToMarwa.dua,
            style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal, fontFamily: 'KFGQPC Uthmanic Script HAFS Regular'),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }
}

class _VerticalDashedAreaPainter extends CustomPainter {
  final double lineSpacing; // Horizontal distance between the lines
  final double dashWidth; // Thickness of each dash
  final double dashHeight; // Vertical length of each dash segment
  final Color lineColor; // Color of the dashes
  final Color fillColor; // Color of the area between the lines

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
