import 'dart:math';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/widgets/loading.dart';
import '../../../controller/nav/umera/tawaf_provider.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/translations/locale_keys.g.dart';
import '../../../utils/theme/colors.dart';
import '../../../utils/theme/text_style.dart';
import '../../../widgets/button.dart';
import '../../../widgets/card.dart';
import '../../../widgets/check_box_card.dart';
import '../../../widgets/custom_image.dart';
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
    return provider.isLoading
        ? Loading()
        : provider.isUmeraCompleted
        ? UmraCompleted()
        : provider.user?.is_safa_marwa_run_completed ?? false
        ? SaiCompletionPage()
        : Column(
          children: [
            if (provider.circleCount != 7)
              CButton(
                shadows: [],
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 30),
                onTap: provider.startTawaf,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImage(path: provider.isInTawaf ? 'assets/svg/pause.svg' : 'assets/svg/play.svg', imageType: ImageType.svg, height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(provider.isInTawaf ? LocaleKeys.off_tracker.tr() : LocaleKeys.start_tawaf.tr(), style: CTextStyle.w500(fontSize: 12, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child:
                  provider.showSafaMarwa
                      ? StartSafaMarwaPage()
                      : Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 50),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final size = constraints.maxHeight * 0.8;
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
                                    size: Size(constraints.maxHeight * 0.8, constraints.maxHeight * 0.8),
                                    painter: DashedCirclePainter(primaryColor: CColors.primary, gradientRadiusFactor: provider.tawafCircleCompletionPercent),
                                  ),
                                ),
                                if ((provider.circleCount != 0 || provider.isInTawaf) && provider.circleCount < 7)
                                  Positioned(
                                    left: (constraints.maxWidth - size) / 2 + trackerDX - 20,
                                    top: (constraints.maxHeight - size) / 2 + trackerDY - 20,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: CColors.solidButtonGradient, boxShadow: primaryShadows),
                                      child: Padding(padding: const EdgeInsets.only(left: 5), child: CustomImage(path: 'assets/svg/play.svg', imageType: ImageType.svg, height: 20)),
                                    ),
                                  ),
                                if (provider.circleCount > 0 && provider.circleCount < 7)
                                  Positioned(
                                    left: (constraints.maxWidth - size) / 2 + tawafCountDX - 42.5,
                                    top: (constraints.maxHeight - size) / 2 + tawafCountDY - 42.5,
                                    child: SizedBox(
                                      width: 85,
                                      height: 85,
                                      child: Stack(
                                        children: [
                                          Center(child: CustomImage(width: 85, height: 85, path: 'assets/svg/tawaf_counter_bg.svg', imageType: ImageType.svg, fit: BoxFit.fill)),
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
                                      return Center(
                                        child: Container(
                                          height: constraints.maxHeight * 0.6,
                                          width: constraints.maxHeight * 0.6,
                                          decoration: BoxDecoration(
                                            gradient: CColors.trackingGradient,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: CColors.primary),
                                            boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
                                          ),
                                          child: Center(
                                            child: Container(
                                              height: constraints.maxHeight * 0.55,
                                              width: constraints.maxHeight * 0.55,
                                              decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, height: 60, width: 60),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Text(LocaleKeys.seven_rounds_completed.tr(), style: CTextStyle.w800(fontSize: 20, color: Colors.white), textAlign: TextAlign.center),
                                                    ),
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
                                        onTap: (provider.isRoundCompleted) ? provider.startNextRound : null,
                                        child: Container(
                                          height: constraints.maxHeight * 0.6,
                                          width: constraints.maxHeight * 0.6,
                                          decoration: BoxDecoration(
                                            gradient: CColors.trackingGradient,
                                            shape: BoxShape.circle,
                                            boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
                                          ),
                                          child: Center(
                                            child: Container(
                                              height: constraints.maxHeight * 0.55,
                                              width: constraints.maxHeight * 0.55,
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
            ),

            if (provider.circleCount < 7)
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
                  CheckBoxCard(margin: EdgeInsets.only(top: 30), title: LocaleKeys.drink_zamzam.tr(), isSelected: provider.isDrinkZamzam, onTap: provider.drinkZamzam),
                  CButton(margin: EdgeInsets.symmetric(vertical: 30), onTap: () => provider.moveToSafaMarwa(context: context, ref: ref), titleWithIcon: true, title: LocaleKeys.continued.tr()),
                ],
              ),
          ],
        );
  }
}
