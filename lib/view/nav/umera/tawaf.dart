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
      padding: ref.watch(tawafProvider).circleCount != 7 ? EdgeInsets.only(bottom: 16, left: 16, right: 16) : EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
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
                                final size = (provider.circleCount == 7) ? constraints.maxHeight * 0.9 : constraints.maxHeight * 0.8;
                                final center = Offset(size / 2, size / 2);
                                final radius = size / 2;

                                final angle = -2 * pi * provider.tawafCircleCompletionPercent + pi;
                                final trackerDX = center.dx + radius * cos(angle);
                                final trackerDY = center.dy + radius * sin(angle);

                                final tawafCountAngle = -2 * pi * 0 + pi;
                                final tawafCountDX = center.dx + radius * cos(tawafCountAngle);
                                final tawafCountDY = center.dy + radius * sin(tawafCountAngle);

                                final tawafCounterSize = size * 0.3;
                                final trackingIndicatorSize = size * 0.15;

                                return Stack(
                                  children: [
                                    Align(
                                      alignment: (provider.circleCount == 7) ? Alignment.topCenter : Alignment.center,
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

                                    Builder(
                                      builder: (context) {
                                        if (provider.circleCount == 7) {
                                          return Align(
                                            alignment: (provider.circleCount == 7) ? Alignment(0, -0.4) : Alignment.center,
                                            child: Container(
                                              height: size * 0.8,
                                              width: size * 0.8,
                                              decoration: BoxDecoration(
                                                gradient: CColors.trackingGradient,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: CColors.primary),
                                                boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
                                              ),
                                              child: Center(
                                                child: Container(
                                                  height: size * 0.75,
                                                  width: size * 0.75,
                                                  decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        CustomImage(
                                                          path: 'assets/svg/complete_check.svg',
                                                          imageType: ImageType.svg,
                                                          height: (size * 0.75) * 0.4,
                                                          width: (size * 0.75) * 0.4,
                                                          margin: EdgeInsets.only(bottom: 8),
                                                        ),
                                                        Text(LocaleKeys.seven_rounds_completed.tr(), style: CTextStyle.w800(fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return Center(
                                          child: GestureDetector(
                                            onTap: (provider.isRoundCompleted) ? () => provider.startNextRound(context) : null,
                                            child: Container(
                                              height: size * 0.75,
                                              width: size * 0.75,
                                              decoration: BoxDecoration(
                                                gradient: CColors.trackingGradient,
                                                shape: BoxShape.circle,
                                                boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
                                              ),
                                              child: Center(
                                                child: Container(
                                                  height: size * 0.7,
                                                  width: size * 0.7,
                                                  decoration: BoxDecoration(gradient: CColors.trackingSecondaryGradient, shape: BoxShape.circle),
                                                  child: Builder(
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children:
                                                              (provider.isRoundCompleted)
                                                                  ? [
                                                                    CustomImage(path: 'assets/svg/istilaam_time.svg', imageType: ImageType.svg, height: 60),
                                                                    Padding(padding: const EdgeInsets.only(top: 10), child: Text(LocaleKeys.istilaam_time.tr(), style: CTextStyle.w900(fontSize: 16))),
                                                                  ]
                                                                  : [
                                                                    CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80),
                                                                    Padding(padding: const EdgeInsets.only(top: 10), child: Text(LocaleKeys.tawaf_tracker.tr(), style: CTextStyle.w900(fontSize: 16))),
                                                                  ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                  ),
                  if (!provider.showSafaMarwa)
                    if (provider.circleCount < 7)
                      Column(
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
                            margin: EdgeInsets.only(top: 16, bottom: 10),
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
                              style: CTextStyle.w500(fontSize: 18, color: CColors.deepTeal),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CheckBoxCard(
                            title: LocaleKeys.now_perform_2_rakats_salah.tr(),
                            isSelected: provider.isPerformed2RakatsSalah,
                            onTap: provider.perform2RakatsSalah,
                            child: Text(LocaleKeys.please_check_makrooh_time_before.tr(), style: CTextStyle.w400(color: Colors.redAccent, fontSize: 14)),
                          ),
                          CheckBoxCard(margin: EdgeInsets.only(top: 10), title: LocaleKeys.drink_zamzam.tr(), isSelected: provider.isDrinkZamzam, onTap: provider.drinkZamzam),
                          CButton(margin: EdgeInsets.symmetric(vertical: 20), onTap: () => provider.moveToSafaMarwa(context: context, ref: ref), titleWithIcon: true, title: LocaleKeys.continued.tr()),
                        ],
                      ),
                  if (provider.showSafaMarwa)
                    if (safaMarwaProv.isRunComplete)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(LocaleKeys.going_to_safa.tr(), style: CTextStyle.w600(fontSize: 20, color: CColors.deepTeal)),
                          BasicCard(
                            margin: EdgeInsets.only(top: 8),
                            backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
                            child: Text(
                              LocaleKeys.going_to_safa_dua.tr(),
                              style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(LocaleKeys.going_to_marwa.tr(), style: CTextStyle.w600(fontSize: 20, color: CColors.deepTeal)),
                          BasicCard(
                            margin: EdgeInsets.only(top: 8),
                            backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
                            child: Text(
                              LocaleKeys.going_to_marwa_dua.tr(),
                              style: CTextStyle.w500(fontSize: 18, color: CColors.deepTeal),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                ],
              ),
    );
  }
}
