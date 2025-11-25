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
              height: 230.pr,
              margin: ScaledEdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(20.pr),
                border: Border.all(color: CColors.primary, width: 2.pr),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80.pr, padding: ScaledEdgeInsets.only(top: 10)),
                  Expanded(child: Padding(padding: ScaledEdgeInsets.symmetric(horizontal: 24), child: Center(child: Text(title, style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center)))),
                  withContinueButton
                      ? CButton(height: 45, title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: () => Navigator.pop(dialogContext), margin: ScaledEdgeInsets.only(bottom: 20))
                      : Padding(
                        padding: ScaledEdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CButton(
                              margin: ScaledEdgeInsets.only(right: isLTR(dialogContext) ? 16 : 0, left: isLTR(dialogContext) ? 0 : 16),
                              height: 45,
                              useTitleWidth: true,
                              padding: ScaledEdgeInsets.zero,
                              backgroundColor: CColors.secondaryBackground,
                              borderColor: CColors.primary,
                              titleColor: CColors.primary,
                              title: LocaleKeys.no.tr(),
                              onTap: () => Navigator.pop(dialogContext, false),
                            ),
                            CButton(
                              margin: ScaledEdgeInsets.only(right: isLTR(dialogContext) ? 0 : 16, left: isLTR(dialogContext) ? 16 : 0),
                              height: 45,
                              useTitleWidth: true,
                              padding: ScaledEdgeInsets.zero,
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
        ],
      ),
    );
  }
}
