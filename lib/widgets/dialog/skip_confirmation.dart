import '../../export.dart';

class SkipConfirmationDialog extends StatelessWidget {
  const SkipConfirmationDialog({super.key});

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: SizeConfig.screenWidth * 0.55,
              padding: SizeConfig.zero,
              margin: SizeConfig.symmetric(horizontal: screenSize.width * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(SizeConfig.r(20)),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: SizeConfig.symmetric(horizontal: 16),
                        child: Text(LocaleKeys.confirmation_dialog.tr(), style: CTextStyle.w900(fontSize: 18, color: CColors.deepTeal), textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  Padding(
                    padding: SizeConfig.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: CButton(
                            margin: SizeConfig.only(left: 16, right: 8),
                            height: 45,
                            backgroundColor: Colors.transparent,
                            shadows: [],
                            title: LocaleKeys.cancel.tr(),
                            onTap: () => Navigator.pop(dialogContext, false),
                            style: CTextStyle.w500(fontSize: 12, color: CColors.primary),
                          ),
                        ),
                        Expanded(
                          child: CButton(
                            margin: SizeConfig.only(left: 8, right: 16),
                            shadows: [],
                            height: 45,
                            title: LocaleKeys.continued.tr(),
                            onTap: () => Navigator.pop(dialogContext, true),
                            style: CTextStyle.w500(fontSize: 12, color: Colors.white),
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
