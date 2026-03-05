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
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(safaMarwaProvider);

    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      titleMargin: context.edgeInsets(top: kToolbarHeight * 0.5, left: 16, right: 16),
      titleType: TitleType.backArrow,
      titleWidget: Padding(padding: context.edgeInsets(right: isLTR(context) ? 28 : 0, left: isLTR(context) ? 0 : 28), child: CustomImage(path: 'assets/svg/mountain.svg', imageType: ImageType.svg, height: context.h(40))),
      showEmblem: false,
      margin: context.edgeInsets(top: kToolbarHeight * 0.5, bottom: kToolbarHeight * 0.5),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 8), child: Text(provider.saiRoundCount % 2 == 0 ? LocaleKeys.safa.tr() : LocaleKeys.marwa.tr(), style: CTextStyle.w500(color: CColors.charcoalBlack, fontSize: 22))),
          Expanded(
            child: LayoutBuilder(
              builder: (context, outerConstraints) {
                return Center(
                  child: SizedBox(
                    height: outerConstraints.maxHeight * 0.85,
                    child: LayoutBuilder(
                      builder: (context, innerConstraints) {
                        return Stack(
                          children: [
                            Container(
                              height: innerConstraints.maxHeight * 0.9,
                              padding: context.edgeInsets(all: 4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(gradient: CColors.trackingGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.3), blurRadius: 30, offset: Offset(0, 5))]),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(gradient: CColors.trackingSecondaryGradient, shape: BoxShape.circle),
                                child: Align(
                                  alignment: Alignment(0, -0.3),
                                  child: FittedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(child: Text(provider.saiRoundCount.toString(), style: CTextStyle.w600(fontSize: 90, color: CColors.primary))),
                                        Center(child: Text('${LocaleKeys.completed.tr()}${isLTR(context) ? ' ' : '                     '}${LocaleKeys.round.tr()}', style: CTextStyle.w900(fontSize: 20))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: provider.onCountTap,
                                onLongPress: provider.updateRoundCount,
                                child: Container(
                                  height: context.r(80),
                                  width: context.r(80),
                                  decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.2), blurRadius: 5, offset: Offset(0, 5))]),
                                  child: Center(child: FittedBox(child: Text(LocaleKeys.count.tr(), style: CTextStyle.w700(fontSize: 22, color: Colors.white)))),
                                ),
                              ),
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
          margin: context.edgeInsets(vertical: 8, horizontal: 16),
          backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
          child: Center(child: Text(dua, style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal, fontFamily: provider.saiRoundCount < 6 ? Helper.arabicTextFontFamily : null), textAlign: TextAlign.center, textDirection: TextDirection.rtl)),
        ),
      ],
    );
  }
}
