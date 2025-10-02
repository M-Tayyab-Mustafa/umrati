import '../../export.dart';

class AlreadyDialog extends StatelessWidget {
  const AlreadyDialog({super.key, required this.isDoingUmra});
  final bool isDoingUmra;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: SizeConfig.screenHeight * 0.3,
              padding: SizeConfig.symmetric(vertical: SizeConfig.screenHeight * 0.0),
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
                      padding: SizeConfig.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
                      child: Center(
                        child: Text(
                          isDoingUmra ? LocaleKeys.already_in_umra.tr() : LocaleKeys.already_in_ziarats.tr(),
                          style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: SizeConfig.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: SizeConfig.only(left: 20, right: 16),
                            child: CButton(height: 45, title: LocaleKeys.start_new.tr(), onTap: () => Navigator.pop(dialogContext, false), style: CTextStyle.w400(fontSize: 12, color: Colors.white)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: SizeConfig.only(left: 16, right: 20),
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
          Positioned(
            top: (SizeConfig.screenHeight * 0.275) + 30,
            left: (SizeConfig.screenWidth * 0.5) - 40,
            child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: SizeConfig.h(80)),
          ),
        ],
      ),
    );
  }
}
