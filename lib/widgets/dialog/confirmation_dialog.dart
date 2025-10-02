import '../../export.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: SizeConfig.h(SizeConfig.screenHeight * 0.25),
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
                  Expanded(
                    child: Padding(
                      padding: SizeConfig.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
                      child: Center(child: Text(title, style: CTextStyle.w900(fontSize: 18, color: CColors.deepTeal), textAlign: TextAlign.center)),
                    ),
                  ),
                  Padding(
                    padding: SizeConfig.only(bottom: 30),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CButton(
                          width: SizeConfig.w(70),
                          padding: SizeConfig.zero,
                          margin: SizeConfig.only(right: 16),
                          backgroundColor: Colors.transparent,
                          borderColor: CColors.primary,
                          titleColor: CColors.primary,
                          shadows: [],
                          title: LocaleKeys.yes.tr(),
                          onTap: () => Navigator.pop(dialogContext, true),
                        ),
                        CButton(
                          margin: SizeConfig.only(left: 16),
                          width: SizeConfig.w(70),
                          padding: EdgeInsets.zero,
                          borderColor: CColors.primary,
                          shadows: [],
                          title: LocaleKeys.no.tr(),
                          onTap: () => Navigator.pop(dialogContext, false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: screenSize.height * 0.31, left: (screenSize.width * 0.5) - 40, child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80)),
        ],
      ),
    );
  }
}
