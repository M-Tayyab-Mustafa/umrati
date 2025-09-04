import '../../export.dart';

class TawafConfirmationDialog extends StatelessWidget {
  const TawafConfirmationDialog({super.key});
  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: screenSize.height * 0.35,
              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.0),
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.05, left: screenSize.width * 0.1, right: screenSize.width * 0.1),
                      child: Center(child: Text(LocaleKeys.meeqaat_task_confirmation.tr(), style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center)),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: CButton(
                            height: 50,
                            title: LocaleKeys.no.tr(),
                            onTap: () => Navigator.pop(dialogContext, false),
                            margin: EdgeInsets.only(bottom: 30),
                            style: CTextStyle.w400(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 16),
                          child: CButton(
                            height: 50,
                            title: LocaleKeys.yes.tr(),
                            onTap: () => Navigator.pop(dialogContext, true),
                            margin: EdgeInsets.only(bottom: 30),
                            style: CTextStyle.w400(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: screenSize.height * 0.275, left: (screenSize.width * 0.5) - 40, child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80)),
        ],
      ),
    );
  }
}
