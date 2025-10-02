import '../../export.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.title, this.withContinueButton = false});
  final String title;
  final bool withContinueButton;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: SizeConfig.h(SizeConfig.screenHeight * 0.2),
              padding: SizeConfig.symmetric(vertical: SizeConfig.screenHeight * 0.0),
              margin: SizeConfig.symmetric(horizontal: SizeConfig.screenWidth * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(SizeConfig.r(20)),
                border: Border.all(color: CColors.primary, width: SizeConfig.w(2)),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Spacer(),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: SizeConfig.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
                      child: Center(child: Text(title, style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center)),
                    ),
                  ),
                  withContinueButton
                      ? CButton(height: 45, title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: () => Navigator.pop(dialogContext), margin: EdgeInsets.only(bottom: 20))
                      : Padding(
                        padding: SizeConfig.only(bottom: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CButton(
                              margin: SizeConfig.only(right: isLTR(dialogContext) ? 16 : 0, left: isLTR(dialogContext) ? 0 : 16),
                              width: 70,
                              height: 45,
                              padding: SizeConfig.zero,
                              backgroundColor: Colors.transparent,
                              borderColor: CColors.primary,
                              titleColor: CColors.primary,
                              shadows: [],
                              title: LocaleKeys.no.tr(),
                              onTap: () => Navigator.pop(dialogContext, false),
                            ),
                            CButton(
                              margin: SizeConfig.only(right: isLTR(dialogContext) ? 0 : 16, left: isLTR(dialogContext) ? 16 : 0),
                              width: 70,
                              height: 45,
                              padding: SizeConfig.zero,
                              shadows: [],
                              title: LocaleKeys.yes.tr(),
                              onTap: () => Navigator.pop(dialogContext, true),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment(0, -0.255), child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: SizeConfig.w(70))),
        ],
      ),
    );
  }
}
