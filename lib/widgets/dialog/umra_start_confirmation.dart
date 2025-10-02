import '../../export.dart';

class UmraStartConfirmationDialog extends StatelessWidget {
  const UmraStartConfirmationDialog({super.key});

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: SizeConfig.screenHeight * 0.6,
              margin: SizeConfig.symmetric(horizontal: SizeConfig.screenWidth * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(SizeConfig.r(20)),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: SizeConfig.only(top: SizeConfig.screenHeight * 0.05, left: 16, right: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(LocaleKeys.umra_start_detail.tr(), style: CTextStyle.w900(fontSize: 20, color: CColors.deepTeal), textAlign: TextAlign.center),
                          CustomImage(
                            margin: SizeConfig.only(top: SizeConfig.screenHeight * 0.03, bottom: SizeConfig.screenHeight * 0.03),
                            path: 'assets/png/home/green_light.png',
                            imageType: ImageType.png,
                            height: SizeConfig.screenHeight * 0.3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CButton(
                    margin: SizeConfig.only(left: 16, right: 16, bottom: 20),
                    height: 45,
                    shadows: [],
                    title: LocaleKeys.yes_i_have_reached.tr(),
                    onTap: () => Navigator.pop(dialogContext),
                    style: CTextStyle.w400(fontSize: 13, color: Colors.white),
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
