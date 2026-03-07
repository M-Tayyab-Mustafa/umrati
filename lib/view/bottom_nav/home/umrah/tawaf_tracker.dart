import '../../../../export.dart';
part '../../../../widgets/dashes_circle.dart';

class TawafTrackerPage extends ConsumerWidget {
  const TawafTrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(umrahProvider);
    return Background(
      canPop: provider.canPop,
      popConfirmationTitle: provider.userActivityType == UserActivityType.umrah ? LocaleKeys.exit_umrah_confirmation.tr() : LocaleKeys.exit_tawaf_confirmation.tr(),
      onPopInvokedWithResult: provider.onPopInvokedWithResult,
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      showEmblem: false,
      margin: context.edgeInsets(top: kToolbarHeight * 0.5),
      titleMargin: context.edgeInsets(top: kToolbarHeight * 0.5, left: 16, right: 16),
      title: LocaleKeys.tawaf_counter.tr(),
      titleAlignment: isLTR(context) ? const Alignment(-0.1, 0) : const Alignment(0.1, 0),
      titleType: TitleType.backArrow,
      child: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              child: LayoutBuilder(
                builder: (context, outerConstraints) {
                  final completeSize = (outerConstraints.biggest.shortestSide * 0.78).clamp(220.0, outerConstraints.maxHeight * 0.98);
                  final completeCheckSize = (completeSize * 0.3).clamp(48.0, 120.0);
                  final completeTitleSize = (completeSize * 0.055).clamp(16.0, 30.0);

                  if (provider.tawafCircleCount == 7) {
                    return Center(child: _TawafCompletedCircle(size: completeSize, checkSize: completeCheckSize, titleSize: completeTitleSize));
                  }

                  return Center(
                    child: SizedBox(
                      height: outerConstraints.maxHeight * 0.9,
                      child: LayoutBuilder(
                        builder: (context, innerConstraints) {
                          final baseCircleSize = (innerConstraints.maxWidth * 0.72).clamp(180.0, innerConstraints.maxWidth);
                          final buttonSize = (baseCircleSize * 0.27).clamp(60.0, 150.0);
                          final circleAvailableHeight = innerConstraints.maxHeight - (buttonSize * 0.55);
                          final circleSize = (circleAvailableHeight < baseCircleSize ? circleAvailableHeight : baseCircleSize).clamp(180.0, innerConstraints.maxWidth);
                          final kabaaHeight = (circleSize * 0.42).clamp(90.0, 260.0);
                          final istilaamIconHeight = (circleSize * 0.3).clamp(38.0, 110.0);
                          final istilaamFontSize = (circleSize * 0.06).clamp(16.0, 34.0);
                          final countFontSize = (circleSize * 0.24).clamp(56.0, 150.0);
                          final countLabelFontSize = (circleSize * 0.055).clamp(14.0, 30.0);
                          final buttonTextSize = (buttonSize * 0.26).clamp(14.0, 28.0);
                          final actionButtonPositionFromBottom = (provider.isRoundCompleted ? 5.h : 0).clamp(0, 5.h).toDouble();

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: _TawafActiveCircle(
                                  circleSize: circleSize,
                                  kabaaHeight: kabaaHeight,
                                  istilaamIconHeight: istilaamIconHeight,
                                  istilaamFontSize: istilaamFontSize,
                                  countFontSize: countFontSize,
                                  countLabelFontSize: countLabelFontSize,
                                  isRoundCompleted: provider.isRoundCompleted,
                                  tawafCircleCount: provider.tawafCircleCount,
                                ),
                              ),
                              Positioned(
                                bottom: actionButtonPositionFromBottom,
                                left: 0,
                                right: 0,
                                child:
                                    provider.isRoundCompleted
                                        ? _TawafActionButton(onTap: provider.startNextRound, label: LocaleKeys.next.tr(), buttonSize: buttonSize, buttonTextSize: buttonTextSize)
                                        : _TawafActionButton(onTap: provider.onCountTap, onLongPress: provider.completeRound, label: LocaleKeys.count.tr(), buttonSize: buttonSize, buttonTextSize: buttonTextSize),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: Padding(padding: context.edgeInsets(left: 16, right: 16, bottom: kToolbarHeight * 0.5), child: _TawafDuaSection(provider: provider))),
        ],
      ),
    );
  }
}

class _TawafCompletedCircle extends StatelessWidget {
  const _TawafCompletedCircle({required this.size, required this.checkSize, required this.titleSize});

  final double size;
  final double checkSize;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.edgeInsets(all: 12),
      height: size,
      width: size,
      padding: context.edgeInsets(all: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: CColors.trackingGradient,
        shape: BoxShape.circle,
        border: Border.all(color: CColors.primary),
        boxShadow: [BoxShadow(color: const Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: const Offset(0, 5))],
      ),
      child: Container(
        padding: context.edgeInsets(vertical: 16, horizontal: 28),
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, size: checkSize, margin: context.edgeInsets(bottom: 8)),
            Text(LocaleKeys.seven_rounds_completed.tr(), style: CTextStyle.w800(fontSize: titleSize, color: Colors.white), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TawafActiveCircle extends StatelessWidget {
  const _TawafActiveCircle({
    required this.circleSize,
    required this.kabaaHeight,
    required this.istilaamIconHeight,
    required this.istilaamFontSize,
    required this.countFontSize,
    required this.countLabelFontSize,
    required this.isRoundCompleted,
    required this.tawafCircleCount,
  });

  final double circleSize;
  final double kabaaHeight;
  final double istilaamIconHeight;
  final double istilaamFontSize;
  final double countFontSize;
  final double countLabelFontSize;
  final bool isRoundCompleted;
  final int tawafCircleCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: circleSize,
      width: circleSize,
      child: Container(
        padding: context.edgeInsets(all: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: CColors.trackingGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF1A172D).withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 5))]),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: CColors.trackingSecondaryGradient, shape: BoxShape.circle),
          child:
              isRoundCompleted
                  ? _IstilaamView(circleSize: circleSize, kabaaHeight: kabaaHeight, istilaamIconHeight: istilaamIconHeight, istilaamFontSize: istilaamFontSize)
                  : _CountView(circleSize: circleSize, tawafCircleCount: tawafCircleCount, countFontSize: countFontSize, countLabelFontSize: countLabelFontSize),
        ),
      ),
    );
  }
}

class _IstilaamView extends StatelessWidget {
  const _IstilaamView({required this.circleSize, required this.kabaaHeight, required this.istilaamIconHeight, required this.istilaamFontSize});

  final double circleSize;
  final double kabaaHeight;
  final double istilaamIconHeight;
  final double istilaamFontSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.2),
      child: Padding(
        padding: context.edgeInsets(horizontal: circleSize * 0.1),
        child: SizedBox(
          width: circleSize * 0.7,
          height: circleSize * 0.5,
          child: Stack(
            children: [
              Center(child: Opacity(opacity: 0.1, child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: kabaaHeight, margin: context.edgeInsets(bottom: 12)))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImage(path: 'assets/svg/istilaam_time.svg', imageType: ImageType.svg, height: istilaamIconHeight, margin: context.edgeInsets(bottom: 12)),
                  Expanded(child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text(LocaleKeys.istilaam_time.tr(), textAlign: TextAlign.center, textScaler: TextScaler.noScaling, style: CTextStyle.w900(fontSize: istilaamFontSize))))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountView extends StatelessWidget {
  const _CountView({required this.circleSize, required this.tawafCircleCount, required this.countFontSize, required this.countLabelFontSize});

  final double circleSize;
  final int tawafCircleCount;
  final double countFontSize;
  final double countLabelFontSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.2),
      child: Padding(
        padding: context.edgeInsets(horizontal: circleSize * 0.1),
        child: SizedBox(
          width: circleSize * 0.7,
          height: circleSize * 0.5,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tawafCircleCount.toString(), textScaler: TextScaler.noScaling, style: CTextStyle.w600(fontSize: countFontSize, color: CColors.primary)),
                Text('${LocaleKeys.completed.tr()}${isLTR(context) ? ' ' : '                     '}${LocaleKeys.round.tr()}', textAlign: TextAlign.center, textScaler: TextScaler.noScaling, style: CTextStyle.w900(fontSize: countLabelFontSize)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TawafActionButton extends StatelessWidget {
  const _TawafActionButton({required this.onTap, required this.label, required this.buttonSize, required this.buttonTextSize, this.onLongPress});

  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String label;
  final double buttonSize;
  final double buttonTextSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: buttonSize,
        width: buttonSize,
        decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF1A172D).withValues(alpha: 0.2), blurRadius: 5, offset: const Offset(0, 5))]),
        child: Center(
          child: Padding(
            padding: context.edgeInsets(all: 10),
            child: SizedBox(
              width: buttonSize * 0.68,
              height: buttonSize * 0.34,
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(label, textAlign: TextAlign.center, textScaler: TextScaler.noScaling, maxLines: 1, style: CTextStyle.w700(fontSize: buttonTextSize, color: Colors.white))),
            ),
          ),
        ),
      ),
    );
  }
}

class _TawafDuaSection extends StatelessWidget {
  const _TawafDuaSection({required this.provider});
  final UmrahNotifier provider;

  @override
  Widget build(BuildContext context) {
    if (provider.tawafCircleCount == 7) {
      return provider.userActivityType == UserActivityType.tawaf
          ? Padding(padding: context.edgeInsets(bottom: kToolbarHeight), child: Consumer(builder: (context, ref, _) => CButton(onTap: provider.moveToSafaMarwa, title: LocaleKeys.go_to_home_screen.tr(), titleWithIcon: true)))
          : _PostTawafChecklist(provider: provider);
    }

    if (provider.isRoundCompleted) {
      return _IstilaamDuaCard(tawafCircleCount: provider.tawafCircleCount, gender: provider.user?.gender);
    }

    return _RoundDuaCard(tawafCircleCount: provider.tawafCircleCount, gender: provider.user?.gender);
  }
}

class _PostTawafChecklist extends StatelessWidget {
  const _PostTawafChecklist({required this.provider});
  final UmrahNotifier provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckBoxCard(
          title: LocaleKeys.now_perform_2_rakats_salah.tr(),
          isSelected: provider.isPerformed2RakatsSalah,
          onTap: provider.perform2RakatsSalah,
          child: Text(LocaleKeys.please_check_makrooh_time_before.tr(), style: CTextStyle.w400(color: Colors.redAccent, fontSize: 12)),
        ),
        CheckBoxCard(margin: context.edgeInsets(vertical: 16), title: LocaleKeys.drink_zamzam.tr(), isSelected: provider.isDrinkZamzam, onTap: provider.drinkZamzam),
        CButton(margin: context.edgeInsets(bottom: 20, top: 25), onTap: provider.moveToSafaMarwa, titleWithIcon: true, title: LocaleKeys.continued.tr()),
      ],
    );
  }
}

class _IstilaamDuaCard extends StatelessWidget {
  const _IstilaamDuaCard({required this.tawafCircleCount, this.gender});
  final int tawafCircleCount;
  final String? gender;

  @override
  Widget build(BuildContext context) {
    final dua = tawafCircleCount == 0 ? IstilaamDua.round1.dua : IstilaamDua.otherRounds.dua;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(gender == Gender.female.name ? ' (${LocaleKeys.in_low_voice.tr()})' : '', style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal)),
        BasicCard(
          margin: context.edgeInsets(vertical: 14),
          backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
          child: Center(child: Text(dua, style: CTextStyle.w500(fontSize: 18, color: CColors.deepTeal, fontFamily: Helper.arabicTextFontFamily), textAlign: TextAlign.center, textDirection: TextDirection.rtl)),
        ),
      ],
    );
  }
}

class _RoundDuaCard extends StatelessWidget {
  const _RoundDuaCard({required this.tawafCircleCount, this.gender});
  final int tawafCircleCount;
  final String? gender;

  String get _duaTitle {
    return switch (tawafCircleCount) {
      0 => LocaleKeys.dua_during_1st_round.tr(),
      1 => LocaleKeys.dua_during_2nd_round.tr(),
      2 => LocaleKeys.dua_during_3rd_round.tr(),
      3 => LocaleKeys.dua_during_4th_round.tr(),
      4 => LocaleKeys.dua_during_5th_round.tr(),
      5 => LocaleKeys.dua_during_6th_round.tr(),
      _ => LocaleKeys.dua_during_7th_round.tr(),
    };
  }

  String get _dua {
    return switch (tawafCircleCount) {
      0 => Dua.round1.dua,
      1 => Dua.round2.dua,
      2 => Dua.round3.dua,
      3 => Dua.round4.dua,
      4 => Dua.round5.dua,
      5 => Dua.round6.dua,
      _ => LocaleKeys.ask_legitimate_needs.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$_duaTitle${gender == Gender.female.name ? ' (${LocaleKeys.in_low_voice.tr()})' : ''}', style: CTextStyle.w600(fontSize: 18, color: CColors.deepTeal)),
        BasicCard(
          margin: context.edgeInsets(vertical: 14),
          backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
          child: Center(child: Text(_dua, style: CTextStyle.w500(fontSize: 18, color: CColors.deepTeal, fontFamily: tawafCircleCount < 6 ? Helper.arabicTextFontFamily : null), textAlign: TextAlign.center, textDirection: TextDirection.rtl)),
        ),
      ],
    );
  }
}
