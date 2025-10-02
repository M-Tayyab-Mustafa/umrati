import '../../../../export.dart';
part '../../../../widgets/dashes_circle.dart';

class TawafTrackerPage extends ConsumerWidget {
  const TawafTrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(umraProvider);
    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      showEmblem: false,
      margin: SizeConfig.only(top: kToolbarHeight * 0.5, bottom: kToolbarHeight * 0.5),
      titleMargin: SizeConfig.only(top: kToolbarHeight * 0.5, left: 16, right: 16),
      titleWidget: Center(
        child: Visibility(
          visible: provider.tawafCircleCount != 7,
          child: CButton(
            shadows: [],
            height: 45,
            margin: SizeConfig.only(right: isLTR(context) ? 40 : 0, left: isLTR(context) ? 0 : 40),
            onTap: provider.pauseAndResumeTracker,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage(path: !provider.isTrackerPaused ? 'assets/svg/pause.svg' : 'assets/svg/play.svg', imageType: ImageType.svg, height: SizeConfig.h(16)),
                Padding(
                  padding: SizeConfig.only(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8),
                  child: Text(!provider.isTrackerPaused ? LocaleKeys.pause_tracker.tr() : LocaleKeys.start_tracker.tr(), style: CTextStyle.w500(fontSize: 12, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      titleType: TitleType.backArrow,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double size = SizeConfig.w(290);
                final double centralContentSize = size * 0.8;
                final double trackingIndicatorSize = size * 0.16;
                final double tawafCounterSize = size * 0.32;
                final double radius = size * 0.5;
                final Offset center = Offset(radius, radius);
                final double angle = -2 * pi * provider.tawafCircleCompletionPercent + pi;
                final double trackerDX = center.dx + radius * cos(angle);
                final double trackerDY = center.dy + radius * sin(angle);
                final double tawafCountAngle = -2 * pi * 0 + pi;
                final double tawafCountDX = center.dx + radius * cos(tawafCountAngle);
                final double tawafCountDY = center.dy + radius * sin(tawafCountAngle);
                return Stack(
                  children: [
                    Center(child: CustomPaint(size: Size(size, size), painter: DashedCirclePainter(primaryColor: CColors.primary, gradientRadiusFactor: provider.tawafCircleCompletionPercent))),
                    if ((provider.tawafCircleCount != 0 || provider.umraModel != null) && provider.tawafCircleCount < 7)
                      Positioned(
                        left: (constraints.maxWidth - size) / 2 + trackerDX - (trackingIndicatorSize / 2),
                        top: (constraints.maxHeight - size) / 2 + trackerDY - (trackingIndicatorSize / 2),
                        child: Container(
                          width: trackingIndicatorSize,
                          height: trackingIndicatorSize,
                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: CColors.solidButtonGradient, boxShadow: primaryShadows),
                          child: Padding(padding: SizeConfig.only(left: 5), child: CustomImage(path: 'assets/svg/play.svg', imageType: ImageType.svg, height: SizeConfig.w(20))),
                        ),
                      ),
                    if (provider.tawafCircleCount > 0 && provider.tawafCircleCount < 7)
                      Positioned(
                        left: (constraints.maxWidth - size) / 2 + tawafCountDX - (tawafCounterSize / 2),
                        top: (constraints.maxHeight - size) / 2 + tawafCountDY - (tawafCounterSize / 2),
                        child: SizedBox(
                          width: tawafCounterSize,
                          height: tawafCounterSize,
                          child: Stack(
                            children: [
                              Center(child: CustomImage(width: tawafCounterSize, height: tawafCounterSize, path: 'assets/svg/tawaf_counter_bg.svg', imageType: ImageType.svg, fit: BoxFit.fill)),
                              Center(
                                child: Padding(padding: SizeConfig.only(bottom: 3), child: Text(provider.tawafCircleCount.toString(), style: CTextStyle.w900(fontSize: 20, color: CColors.primary))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Center(
                      child: switch (provider.tawafCircleCount) {
                        7 => Container(
                          width: centralContentSize * 1.1,
                          padding: SizeConfig.all(8),
                          alignment: Alignment.center,
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
                                CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, size: SizeConfig.w(size * 0.25), margin: SizeConfig.only(bottom: 8)),
                                Text(LocaleKeys.seven_rounds_completed.tr(), style: CTextStyle.w800(fontSize: 20, color: Colors.white), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        _ => GestureDetector(
                          onTap: (provider.isRoundCompleted) ? provider.startNextRound : null,
                          child: Container(
                            width: centralContentSize,
                            padding: SizeConfig.all(8),
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
                                  CustomImage(
                                    path: provider.isRoundCompleted ? 'assets/svg/istilaam_time.svg' : 'assets/svg/kabaa.svg',
                                    imageType: ImageType.svg,
                                    height: SizeConfig.w(80),
                                    margin: SizeConfig.only(bottom: 12),
                                  ),
                                  Text(provider.isRoundCompleted ? LocaleKeys.istilaam_time.tr() : LocaleKeys.tawaf_tracker.tr(), style: CTextStyle.w900(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(padding: SizeConfig.symmetric(horizontal: 16), child: _buildDuaWidget(context: context, provider: provider)),
        ],
      ),
    );
  }

  Widget _buildDuaWidget({required BuildContext context, required UmraNotifier provider}) {
    switch (provider.tawafCircleCount) {
      case 7:
        return provider.userActivityType == UserActivityType.tawaf
            ? Padding(
              padding: SizeConfig.only(bottom: kToolbarHeight),
              child: Consumer(builder: (context, ref, child) => CButton(onTap: provider.moveToSafaMarwa, title: LocaleKeys.go_to_home_screen.tr(), titleWithIcon: true)),
            )
            : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckBoxCard(
                  title: LocaleKeys.now_perform_2_rakats_salah.tr(),
                  isSelected: provider.isPerformed2RakatsSalah,
                  onTap: provider.perform2RakatsSalah,
                  child: Text(LocaleKeys.please_check_makrooh_time_before.tr(), style: CTextStyle.w400(color: Colors.redAccent, fontSize: 12, fontFamily: 'KFGQPC Uthmanic Script HAFS Regular')),
                ),
                CheckBoxCard(margin: SizeConfig.symmetric(vertical: 16), title: LocaleKeys.drink_zamzam.tr(), isSelected: provider.isDrinkZamzam, onTap: provider.drinkZamzam),
                CButton(margin: SizeConfig.only(bottom: 16, top: 25), onTap: provider.moveToSafaMarwa, titleWithIcon: true, title: LocaleKeys.continued.tr()),
              ],
            );
      default:
        {
          if (provider.isRoundCompleted) {
            String dua = switch (provider.tawafCircleCount) {
              1 => IstilaamDua.round1.dua,
              _ => IstilaamDua.otherRounds.dua,
            };
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(provider.user?.gender == Gender.female.name ? LocaleKeys.in_low_voice.tr() : '', style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal)),
                BasicCard(
                  margin: SizeConfig.symmetric(vertical: 14),
                  backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
                  child: Center(child: Text(dua, style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center, textDirection: TextDirection.rtl)),
                ),
              ],
            );
          } else {
            String duaTitle = switch (provider.tawafCircleCount) {
              0 => LocaleKeys.dua_during_1st_round.tr(),
              1 => LocaleKeys.dua_during_2nd_round.tr(),
              2 => LocaleKeys.dua_during_3rd_round.tr(),
              3 => LocaleKeys.dua_during_4th_round.tr(),
              4 => LocaleKeys.dua_during_5th_round.tr(),
              5 => LocaleKeys.dua_during_6th_round.tr(),
              _ => LocaleKeys.dua_during_7th_round.tr(),
            };
            String dua = switch (provider.tawafCircleCount) {
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
                Text('$duaTitle${provider.user?.gender == Gender.female.name ? ' (${LocaleKeys.in_low_voice.tr()})' : ''}', style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal)),
                BasicCard(
                  onTap: provider.debugSkipTawaf,
                  margin: SizeConfig.symmetric(vertical: 14),
                  backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
                  child: Center(
                    child: Text(
                      dua,
                      style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal, fontFamily: 'KFGQPC Uthmanic Script HAFS Regular'),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            );
          }
        }
    }
  }
}
