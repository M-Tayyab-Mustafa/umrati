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
              height: dialogContext.h(230),
              margin: dialogContext.edgeInsets(horizontal: 28),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(dialogContext.r(20)),
                border: Border.all(color: CColors.primary, width: dialogContext.w(2)),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: dialogContext.h(70), padding: dialogContext.edgeInsets(top: 10)),
                  Expanded(child: Padding(padding: dialogContext.edgeInsets(horizontal: 24), child: Center(child: Text(title, style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center)))),
                  withContinueButton
                      ? CButton(height: 45, title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: () => Navigator.pop(dialogContext), margin: dialogContext.edgeInsets(bottom: 20))
                      : Padding(
                        padding: dialogContext.edgeInsets(bottom: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CButton(
                              margin: dialogContext.edgeInsets(right: isLTR(dialogContext) ? 16 : 0, left: isLTR(dialogContext) ? 0 : 16),
                              height: 45,
                              useTitleWidth: true,
                              padding: EdgeInsets.zero,
                              backgroundColor: CColors.secondaryBackground,
                              borderColor: CColors.primary,
                              titleColor: CColors.primary,
                              title: LocaleKeys.no.tr(),
                              onTap: () => Navigator.pop(dialogContext, false),
                            ),
                            CButton(
                              margin: dialogContext.edgeInsets(right: isLTR(dialogContext) ? 0 : 16, left: isLTR(dialogContext) ? 16 : 0),
                              height: 45,
                              useTitleWidth: true,
                              padding: EdgeInsets.zero,
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
