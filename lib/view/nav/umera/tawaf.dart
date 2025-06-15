import '../../../export.dart';
import 'safa_marwa.dart';
import 'sai_completion.dart';
import 'umra_completed.dart';
part '../../../widgets/dashes_circle.dart';

class StartTawafPage extends ConsumerStatefulWidget {
  const StartTawafPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartTawafPageState();
}

class _StartTawafPageState extends ConsumerState<StartTawafPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tawafProvider).initialization(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(tawafProvider);
    var safaMarwaProv = ref.watch(safaMarwaProvider);
    return Padding(
      padding: ref.watch(tawafProvider).circleCount != 7 ? EdgeInsets.only(left: 16, right: 16) : EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
      child:
          provider.isLoading
              ? Loading()
              : provider.isUmeraCompleted
              ? UmraCompleted()
              : provider.isSafaMarwaComplete
              ? SaiCompletionPage()
              : Column(
                children: [
                  if (provider.circleCount != 7)
                    CButton(
                      shadows: [],
                      height: 50,
                      margin: EdgeInsets.symmetric(vertical: 30),
                      onTap: () => provider.startTawaf(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImage(path: provider.isInTawaf ? 'assets/svg/pause.svg' : 'assets/svg/play.svg', imageType: ImageType.svg, height: 16),
                          Padding(
                            padding: EdgeInsets.only(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8),
                            child: Text(provider.isInTawaf ? LocaleKeys.off_tracker.tr() : LocaleKeys.start_tawaf.tr(), style: CTextStyle.w500(fontSize: 12, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child:
                        provider.showSafaMarwa
                            ? StartSafaMarwaPage()
                            : LayoutBuilder(
                              builder: (context, constraints) {
                                final size = constraints.maxWidth * 0.84;
                                final trackingIndicatorSize = size * 0.14;
                                final tawafCounterSize = size * 0.3;
                                final centralContentSize = size * 0.77;
                                final center = Offset(size / 2, size / 2);
                                final radius = size / 2;
                                final angle = -2 * pi * provider.tawafCircleCompletionPercent + pi;
                                final trackerDX = center.dx + radius * cos(angle);
                                final trackerDY = center.dy + radius * sin(angle);
                                final tawafCountAngle = -2 * pi * 0 + pi;
                                final tawafCountDX = center.dx + radius * cos(tawafCountAngle);
                                final tawafCountDY = center.dy + radius * sin(tawafCountAngle);

                                return Stack(
                                  children: [
                                    Center(
                                      child: CustomPaint(
                                        size: Size(size, size),
                                        painter: DashedCirclePainter(primaryColor: CColors.primary, gradientRadiusFactor: provider.tawafCircleCompletionPercent),
                                      ),
                                    ),
                                    if ((provider.circleCount != 0 || provider.isInTawaf) && provider.circleCount < 7)
                                      Positioned(
                                        left: (constraints.maxWidth - size) / 2 + trackerDX - (trackingIndicatorSize / 2),
                                        top: (constraints.maxHeight - size) / 2 + trackerDY - (trackingIndicatorSize / 2),
                                        child: Container(
                                          width: trackingIndicatorSize,
                                          height: trackingIndicatorSize,
                                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: CColors.solidButtonGradient, boxShadow: primaryShadows),
                                          child: Padding(padding: const EdgeInsets.only(left: 5), child: CustomImage(path: 'assets/svg/play.svg', imageType: ImageType.svg, height: 20)),
                                        ),
                                      ),
                                    if (provider.circleCount > 0 && provider.circleCount < 7)
                                      Positioned(
                                        left: (constraints.maxWidth - size) / 2 + tawafCountDX - (tawafCounterSize / 2),
                                        top: (constraints.maxHeight - size) / 2 + tawafCountDY - (tawafCounterSize / 2),
                                        child: SizedBox(
                                          width: tawafCounterSize,
                                          height: tawafCounterSize,
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: CustomImage(
                                                  width: tawafCounterSize,
                                                  height: tawafCounterSize,
                                                  path: 'assets/svg/tawaf_counter_bg.svg',
                                                  imageType: ImageType.svg,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 3),
                                                  child: Text(provider.circleCount.toString(), style: CTextStyle.w900(fontSize: 16, color: CColors.primary)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Center(
                                      child: _buildCentralContent(
                                        size: centralContentSize,
                                        isRoundCompleted: provider.isRoundCompleted,
                                        isCompleted: provider.circleCount == 7,
                                        provider: provider,
                                        context: context,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                  ),
                  _buildDuaContent(context: context, isShowingSafaMarwa: provider.showSafaMarwa, provider: provider, safaMarwaProv: safaMarwaProv),
                ],
              ),
    );
  }

  Widget _buildCentralContent({required BuildContext context, required double size, required bool isRoundCompleted, required bool isCompleted, required TawafNotifier provider}) {
    if (isCompleted) {
      return Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        padding: EdgeInsets.all(size * 0.03),
        decoration: BoxDecoration(
          gradient: CColors.trackingGradient,
          shape: BoxShape.circle,
          border: Border.all(color: CColors.primary),
          boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, height: size * 0.35, width: size * 0.35, margin: EdgeInsets.only(bottom: 8)),
              Text(LocaleKeys.seven_rounds_completed.tr(), style: CTextStyle.w800(fontSize: 18, color: Colors.white), textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: (provider.isRoundCompleted) ? () => provider.startNextRound(context) : null,
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(size * 0.03),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: CColors.trackingGradient,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: CColors.trackingSecondaryGradient, shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomImage(path: isRoundCompleted ? 'assets/svg/istilaam_time.svg' : 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: size * 0.25, margin: EdgeInsets.only(bottom: 12)),
              Text(isRoundCompleted ? LocaleKeys.istilaam_time.tr() : LocaleKeys.tawaf_tracker.tr(), style: CTextStyle.w900(fontSize: isLTR(context) ? 14 : 22)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDuaContent({required BuildContext context, required bool isShowingSafaMarwa, required TawafNotifier provider, required SafaMarwaNotifier safaMarwaProv}) {
    if (isShowingSafaMarwa) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(safaMarwaProv.isRunComplete ? LocaleKeys.going_to_safa.tr() : LocaleKeys.going_to_marwa.tr(), style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal)),
          BasicCard(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
            child: Text(
              safaMarwaProv.isRunComplete ? LocaleKeys.going_to_safa_dua.tr() : LocaleKeys.going_to_marwa_dua.tr(),
              style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal, fontFamily: 'KFGQPC Uthmanic Script HAFS Regular'),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      );
    }
    return provider.circleCount < 7
        ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.circleCount == 0
                  ? LocaleKeys.dua_during_1st_round.tr()
                  : provider.circleCount == 1
                  ? LocaleKeys.dua_during_2nd_round.tr()
                  : provider.circleCount == 2
                  ? LocaleKeys.dua_during_3rd_round.tr()
                  : provider.circleCount == 3
                  ? LocaleKeys.dua_during_4th_round.tr()
                  : provider.circleCount == 4
                  ? LocaleKeys.dua_during_5th_round.tr()
                  : provider.circleCount == 5
                  ? LocaleKeys.dua_during_6th_round.tr()
                  : LocaleKeys.dua_during_7th_round.tr(),
              style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal),
            ),
            BasicCard(
              margin: EdgeInsets.symmetric(vertical: 14),
              backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
              child: Text(
                provider.circleCount == 0
                    ? LocaleKeys.round_one_dua.tr()
                    : provider.circleCount == 1
                    ? LocaleKeys.round_second_dua.tr()
                    : provider.circleCount == 2
                    ? LocaleKeys.round_third_dua.tr()
                    : provider.circleCount == 3
                    ? LocaleKeys.round_fourth_dua.tr()
                    : provider.circleCount == 4
                    ? LocaleKeys.round_fifth_dua.tr()
                    : provider.circleCount == 5
                    ? LocaleKeys.round_sixth_dua.tr()
                    : LocaleKeys.round_seventh_dua.tr(),
                style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        )
        : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckBoxCard(
              margin: EdgeInsets.only(top: 16),
              title: LocaleKeys.now_perform_2_rakats_salah.tr(),
              isSelected: provider.isPerformed2RakatsSalah,
              onTap: provider.perform2RakatsSalah,
              child: Text(LocaleKeys.please_check_makrooh_time_before.tr(), style: CTextStyle.w400(color: Colors.redAccent, fontSize: 14, fontFamily: 'KFGQPC Uthmanic Script HAFS Regular')),
            ),
            CheckBoxCard(margin: EdgeInsets.symmetric(vertical: 10), title: LocaleKeys.drink_zamzam.tr(), isSelected: provider.isDrinkZamzam, onTap: provider.drinkZamzam),
            CButton(margin: EdgeInsets.only(bottom: 16), onTap: () => provider.moveToSafaMarwa(context: context, ref: ref), titleWithIcon: true, title: LocaleKeys.continued.tr()),
          ],
        );
  }
}
