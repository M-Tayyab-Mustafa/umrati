import '../../export.dart';

class StartConfirmationDialog extends StatelessWidget {
  const StartConfirmationDialog({super.key, this.fromUmra = true});
  final bool fromUmra;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: SizeConfig.h(fromUmra ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight * 0.4),
              margin: SizeConfig.symmetric(horizontal: SizeConfig.screenWidth * 0.08),
              decoration: BoxDecoration(
                color: fromUmra ? CColors.secondaryBackground : Colors.white,
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
                          Text(
                            fromUmra ? LocaleKeys.umra_start_detail.tr() : LocaleKeys.please_reach_safa_start_point.tr(),
                            style: CTextStyle.w900(fontSize: 20, color: CColors.deepTeal),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: CustomImage(
                              margin: SizeConfig.symmetric(vertical: SizeConfig.screenHeight * 0.03),
                              path: fromUmra ? 'assets/png/home/green_light.png' : 'assets/png/home/safa_marwa.png',
                              imageType: ImageType.png,
                              fit: BoxFit.fitWidth,
                            ),
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
                    onTap: () => Navigator.pop(dialogContext, true),
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
