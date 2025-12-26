import '../../export.dart';

class AlreadyDialog extends StatelessWidget {
  const AlreadyDialog({super.key, required this.isDoingUmrah});
  final bool isDoingUmrah;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: 300.pr,
              padding: ScaledEdgeInsets.zero,
              margin: ScaledEdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(color: CColors.secondaryBackground, borderRadius: BorderRadius.circular(20.pr), border: Border.all(color: CColors.primary, width: 2), boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList()),
              child: Column(
                children: [
                  CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80.pr, padding: ScaledEdgeInsets.only(top: 10)),
                  Expanded(
                    child: Padding(
                      padding: ScaledEdgeInsets.symmetric(horizontal: 28),
                      child: Center(child: Text(isDoingUmrah ? LocaleKeys.already_in_umrah.tr() : LocaleKeys.already_in_ziaraats.tr(), style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center)),
                    ),
                  ),
                  Padding(
                    padding: ScaledEdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: ScaledEdgeInsets.only(left: isLTR(dialogContext) ? 20 : 16, right: isLTR(dialogContext) ? 16 : 20),
                            child: CButton(
                              backgroundColor: CColors.secondaryBackground,
                              borderColor: CColors.primary,
                              titleColor: CColors.primary,
                              height: 45,
                              title: LocaleKeys.start_new.tr(),
                              onTap: () => Navigator.pop(dialogContext, false),
                              style: CTextStyle.w400(fontSize: 12, color: CColors.primary),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: ScaledEdgeInsets.only(left: isLTR(dialogContext) ? 16 : 20, right: isLTR(dialogContext) ? 20 : 16),
                            child: CButton(height: 45, title: LocaleKeys.continued.tr(), onTap: () => Navigator.pop(dialogContext, true), style: CTextStyle.w400(fontSize: 12, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
