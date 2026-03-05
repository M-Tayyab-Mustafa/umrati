import '../../../../export.dart';

class UmrahCompleted extends StatelessWidget {
  const UmrahCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      margin: context.edgeInsets(top: kToolbarHeight * 0.5),
      showEmblem: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: context.edgeInsets(vertical: 20),
              child: SizedBox(
                height: context.h(200),
                child: Stack(
                  children: [
                    CustomImage(
                      path: 'assets/svg/kaba_image.svg',
                      imageType: ImageType.svg,
                      height: context.h(300),
                      fit: BoxFit.fill,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: context.r(90),
                        width: context.r(90),
                        decoration: BoxDecoration(
                          gradient: CColors.solidButtonGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            size: context.r(60),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(LocaleKeys.congratulations.tr(), style: CTextStyle.w800()),
            Padding(
              padding: context.edgeInsets(vertical: 30),
              child: Text(
                LocaleKeys.your_umrah_has_been_completed.tr(),
                style: CTextStyle.w600(color: CColors.primary),
              ),
            ),
            Text(
              LocaleKeys.may_allah_accept_your_umrah_ameen.tr(),
              style: CTextStyle.w600(color: CColors.deepTeal),
              textAlign: TextAlign.center,
            ),
            Consumer(
              builder:
                  (context, ref, child) => CButton(
                    margin: context.edgeInsets(top: 50),
                    onTap: ref.read(umrahProvider).goToHome,
                    title: LocaleKeys.go_to_home_screen.tr(),
                    titleWithIcon: true,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
