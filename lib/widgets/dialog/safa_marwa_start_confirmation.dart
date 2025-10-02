import '../../export.dart';

class SafaMarwaStartConfirmationDialog extends StatelessWidget {
  const SafaMarwaStartConfirmationDialog({super.key});

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: SizeConfig.screenHeight * 0.45,
              margin: SizeConfig.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(SizeConfig.r(20)),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: SizeConfig.only(top: SizeConfig.screenHeight * 0.04, left: SizeConfig.screenWidth * 0.1, right: SizeConfig.screenWidth * 0.1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(LocaleKeys.please_reach_safa_start_point.tr(), style: CTextStyle.w900(fontSize: 20, color: CColors.deepTeal), textAlign: TextAlign.center),
                          CustomImage(path: 'assets/png/home/safa_marwa.png', imageType: ImageType.png, height: SizeConfig.screenHeight * 0.2, fit: BoxFit.fill),
                        ],
                      ),
                    ),
                  ),
                  CButton(
                    margin: SizeConfig.only(bottom: 20, left: 16, right: 16),
                    height: 45,
                    shadows: [],
                    title: LocaleKeys.yes_i_have_reached.tr(),
                    onTap: () => Navigator.pop(dialogContext),
                    style: CTextStyle.w400(fontSize: 12, color: Colors.white),
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
