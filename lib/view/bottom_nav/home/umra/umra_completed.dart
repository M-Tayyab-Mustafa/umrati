import '../../../../export.dart';

class UmraCompleted extends StatelessWidget {
  const UmraCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      margin: SizeConfig.only(top: kToolbarHeight * 0.5),
      showEmblem: false,
      child: Column(
        children: [
          Padding(
            padding: SizeConfig.symmetric(vertical: 20),
            child: SizedBox(
              height: SizeConfig.w(SizeConfig.screenHeight * 0.27),
              child: Stack(
                children: [
                  CustomImage(path: 'assets/svg/kaba_image.svg', imageType: ImageType.svg, height: SizeConfig.h(SizeConfig.screenHeight * 0.27), fit: BoxFit.fill),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: SizeConfig.h(SizeConfig.screenHeight * 0.1),
                      width: SizeConfig.h(SizeConfig.screenHeight * 0.1),
                      decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
                      child: Center(child: Icon(Icons.check, size: SizeConfig.h(SizeConfig.screenHeight * 0.07), color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(LocaleKeys.congratulations.tr(), style: CTextStyle.w800()),
          Padding(padding: SizeConfig.symmetric(vertical: 30), child: Text(LocaleKeys.your_umra_has_been_completed.tr(), style: CTextStyle.w600(color: CColors.primary))),
          Text(LocaleKeys.may_allah_accept_your_umra_ameen.tr(), style: CTextStyle.w600(color: CColors.deepTeal), textAlign: TextAlign.center),
          Consumer(builder: (context, ref, child) => CButton(margin: SizeConfig.only(top: 50), onTap: ref.read(umrahProvider).goToHome, title: LocaleKeys.go_to_home_screen.tr(), titleWithIcon: true)),
        ],
      ),
    );
  }
}
