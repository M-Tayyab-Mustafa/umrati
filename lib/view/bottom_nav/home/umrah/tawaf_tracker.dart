import '../../../../export.dart';
part '../../../../widgets/dashes_circle.dart';

class TawafTrackerPage extends ConsumerWidget {
  const TawafTrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(umrahProvider);
    return Background(
      canPop: provider.canPop,
      popConfirmationTitle: LocaleKeys.exit_umrah_confirmation.tr(),
      onPopInvokedWithResult: provider.onPopInvokedWithResult,
      logoAlign: Alignment.center,
      backgroundType: provider.tawafCircleCount == 7 ? BackgroundType.logo : BackgroundType.logoWithSkip,
      onSkipTap: provider.debugSkipTawaf,
      showEmblem: false,
      margin: ScaledEdgeInsets.only(top: kToolbarHeight * 0.5),
      titleMargin: ScaledEdgeInsets.only(top: kToolbarHeight * 0.5, left: 16, right: 16),
      title: LocaleKeys.tawaf_counter.tr(),
      titleAlignment: isLTR(context) ? Alignment(-0.1, 0) : Alignment(0.1, 0),
      titleType: TitleType.backArrow,
      child: Column(
        children: [
          // Align(
          //   alignment: Alignment(0, provider.tawafCircleCount == 7 ? -0.85 : -0.5),
          //   child: SizedBox(
          //     height: SizeConfig.h(340),
          //     child: LayoutBuilder(
          //       builder: (context, constraints) {
          //         // final double trackingIndicatorSize = size * 0.16;
          //         // final double tawafCounterSize = size * 0.32;
          //         // final double radius = size * 0.5;
          //         // final Offset center = Offset(radius, radius);
          //         // final double angle = -2 * pi * provider.tawafCircleCompletionPercent + pi;
          //         // final double trackerDX = center.dx + radius * cos(angle);
          //         // final double trackerDY = center.dy + radius * sin(angle);
          //         // final double tawafCountAngle = -2 * pi * 0 + pi;
          //         // final double tawafCountDX = center.dx + radius * cos(tawafCountAngle);
          //         // final double tawafCountDY = center.dy + radius * sin(tawafCountAngle);
          //         return Stack(
          //           children: [
          //             // Center(child: CustomPaint(size: Size(size, size), painter: DashedCirclePainter(primaryColor: CColors.primary, gradientRadiusFactor: provider.tawafCircleCompletionPercent))),
          //             // if ((provider.tawafCircleCount != 0 || provider.umrahModel != null) && provider.tawafCircleCount < 7)
          //             //   Positioned(
          //             //     left: (constraints.maxWidth - size) / 2 + trackerDX - (trackingIndicatorSize / 2),
          //             //     top: (constraints.maxHeight - size) / 2 + trackerDY - (trackingIndicatorSize / 2),
          //             //     child: Container(
          //             //       width: trackingIndicatorSize,
          //             //       height: trackingIndicatorSize,
          //             //       decoration: BoxDecoration(shape: BoxShape.circle, gradient: CColors.solidButtonGradient, boxShadow: primaryShadows),
          //             //       child: Padding(padding: ScaledEdgeInsets.only(left: 5), child: CustomImage(path: 'assets/svg/play.svg', imageType: ImageType.svg, height: SizeConfig.w(20))),
          //             //     ),
          //             //   ),
          //             // if (provider.tawafCircleCount > 0 && provider.tawafCircleCount < 7)
          //             //   Positioned(
          //             //     left: (constraints.maxWidth - size) / 2 + tawafCountDX - (tawafCounterSize / 2),
          //             //     top: (constraints.maxHeight - size) / 2 + tawafCountDY - (tawafCounterSize / 2),
          //             //     child: SizedBox(
          //             //       width: tawafCounterSize,
          //             //       height: tawafCounterSize,
          //             //       child: Stack(
          //             //         children: [
          //             //           Center(child: CustomImage(width: tawafCounterSize, height: tawafCounterSize, path: 'assets/svg/tawaf_counter_bg.svg', imageType: ImageType.svg, fit: BoxFit.fill)),
          //             //           Center(child: Padding(padding: ScaledEdgeInsets.only(bottom: 3), child: Text(provider.tawafCircleCount.toString(), style: CTextStyle.w900(fontSize: 20, color: CColors.primary)))),
          //             //         ],
          //             //       ),
          //             //     ),
          //             //   ),

          //           ],
          //         );
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            child: Center(
              child: switch (provider.tawafCircleCount) {
                7 => Container(
                  width: 280.pr,
                  padding: ScaledEdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: CColors.trackingGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: CColors.primary),
                    boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
                  ),
                  child: Container(
                    padding: ScaledEdgeInsets.symmetric(vertical: 16, horizontal: 28),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, size: 130.pr, margin: ScaledEdgeInsets.only(bottom: 8)),
                        Text(LocaleKeys.seven_rounds_completed.tr(), style: CTextStyle.w800(fontSize: 20, color: Colors.white), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                _ => GestureDetector(
                  child: Container(
                    width: 280.pr,
                    padding: ScaledEdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(gradient: CColors.trackingGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.3), blurRadius: 30, offset: Offset(0, 5))]),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(gradient: CColors.trackingSecondaryGradient, shape: BoxShape.circle),
                      child:
                          (provider.isRoundCompleted)
                              ? Stack(
                                children: [
                                  Align(
                                    alignment: Alignment(0, -0.2),
                                    child: Stack(
                                      children: [
                                        Center(child: Opacity(opacity: 0.1, child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 250.pr, margin: ScaledEdgeInsets.only(bottom: 12)))),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CustomImage(path: 'assets/svg/istilaam_time.svg', imageType: ImageType.svg, height: 100.pr, margin: ScaledEdgeInsets.only(bottom: 12)),
                                            Text(LocaleKeys.istilaam_time.tr(), style: CTextStyle.w900(fontSize: 22)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, provider.tawafCircleCount == 0 ? 0.9 : 0.75),
                                    child: GestureDetector(
                                      onTap: provider.startNextRound,
                                      child: Container(
                                        height: 100.pr,
                                        width: 100.pr,
                                        decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.2), blurRadius: 5, offset: Offset(0, 5))]),
                                        child: Center(child: FittedBox(child: Text(LocaleKeys.next.tr(), style: CTextStyle.w700(fontSize: 20, color: Colors.white)))),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Stack(
                                children: [
                                  Align(
                                    alignment: Alignment(0, -0.2),
                                    child: FittedBox(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(child: Text(provider.tawafCircleCount.toString(), style: CTextStyle.w600(fontSize: 90, color: CColors.primary))),
                                          Center(child: Text('${LocaleKeys.completed.tr()}${isLTR(context) ? ' ' : '                     '}${LocaleKeys.round.tr()}', style: CTextStyle.w900(fontSize: 20))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, 0.7),
                                    child: GestureDetector(
                                      onTap: provider.onCountTap,
                                      onLongPress: provider.completeRound,
                                      child: Container(
                                        height: 100.pr,
                                        width: 100.pr,
                                        decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.2), blurRadius: 5, offset: Offset(0, 5))]),
                                        child: Center(child: FittedBox(child: Text(LocaleKeys.count.tr(), style: CTextStyle.w700(fontSize: 20, color: Colors.white)))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              },
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: Padding(padding: ScaledEdgeInsets.only(left: 16, right: 16, bottom: kToolbarHeight * 0.5), child: _buildDuaWidget(context: context, provider: provider))),
        ],
      ),
    );
  }

  Widget _buildDuaWidget({required BuildContext context, required UmrahNotifier provider}) {
    switch (provider.tawafCircleCount) {
      case 7:
        return provider.userActivityType == UserActivityType.tawaf
            ? Padding(padding: ScaledEdgeInsets.only(bottom: kToolbarHeight), child: Consumer(builder: (context, ref, child) => CButton(onTap: provider.moveToSafaMarwa, title: LocaleKeys.go_to_home_screen.tr(), titleWithIcon: true)))
            : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckBoxCard(
                  title: LocaleKeys.now_perform_2_rakats_salah.tr(),
                  isSelected: provider.isPerformed2RakatsSalah,
                  onTap: provider.perform2RakatsSalah,
                  child: Text(LocaleKeys.please_check_makrooh_time_before.tr(), style: CTextStyle.w400(color: Colors.redAccent, fontSize: 12)),
                ),
                CheckBoxCard(margin: ScaledEdgeInsets.symmetric(vertical: 16), title: LocaleKeys.drink_zamzam.tr(), isSelected: provider.isDrinkZamzam, onTap: provider.drinkZamzam),
                CButton(margin: ScaledEdgeInsets.only(bottom: 16, top: 25), onTap: provider.moveToSafaMarwa, titleWithIcon: true, title: LocaleKeys.continued.tr()),
              ],
            );
      default:
        {
          if (provider.isRoundCompleted) {
            String dua = switch (provider.tawafCircleCount) {
              0 => IstilaamDua.round1.dua,
              _ => IstilaamDua.otherRounds.dua,
            };
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(provider.user?.gender == Gender.female.name ? LocaleKeys.in_low_voice.tr() : '', style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal)),
                BasicCard(
                  margin: ScaledEdgeInsets.symmetric(vertical: 14),
                  backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
                  child: Center(child: Text(dua, style: CTextStyle.w500(fontSize: 18, color: CColors.deepTeal, fontFamily: Helper.arabicTextFontFamily), textAlign: TextAlign.center, textDirection: TextDirection.rtl)),
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
                  margin: ScaledEdgeInsets.symmetric(vertical: 14),
                  backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
                  child: Center(
                    child: Text(dua, style: CTextStyle.w500(fontSize: 18, color: CColors.deepTeal, fontFamily: provider.tawafCircleCount < 6 ? Helper.arabicTextFontFamily : null), textAlign: TextAlign.center, textDirection: TextDirection.rtl),
                  ),
                ),
              ],
            );
          }
        }
    }
  }
}
