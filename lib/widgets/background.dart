import '../export.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
    this.backgroundType = BackgroundType.empty,
    this.margin,
    this.title,
    this.titleAlignment,
    this.logoAlign,
    this.onSkipTap,
    this.titleMargin,
    this.titleStyle,
    this.showEmblem = true,
    this.isSkipLoading = false,
  });
  final Widget child;
  final BackgroundType backgroundType;
  final String? title;
  final Alignment? titleAlignment;
  final Alignment? logoAlign;
  final VoidCallback? onSkipTap;
  final EdgeInsets? margin;
  final EdgeInsets? titleMargin;
  final TextStyle? titleStyle;
  final bool showEmblem;
  final bool isSkipLoading;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Opacity(opacity: 0.1, child: CustomImage(path: 'assets/png/background.png', imageType: ImageType.png, height: screenSize.height, width: screenSize.width, fit: BoxFit.fill)),
          Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x73737300).withValues(alpha: 0.05), Color.fromARGB(255, 168, 255, 178).withValues(alpha: 0.25)],
                stops: [0.3, 1],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: CustomImage(path: 'assets/svg/islamic_pattern.svg', imageType: ImageType.svg, fit: BoxFit.cover, height: screenSize.height * 2, width: screenSize.width * 2, color: Colors.white),
          ),
          Opacity(opacity: 0.4, child: CustomImage(path: 'assets/svg/modal.svg', imageType: ImageType.svg, fit: BoxFit.cover, height: screenSize.height * 2, width: screenSize.width * 2)),
          if (showEmblem)
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.15,
                child: CustomImage(path: 'assets/svg/emblem.svg', imageType: ImageType.svg, color: CColors.primary, height: screenSize.height * 0.22, width: screenSize.width * 0.8),
              ),
            ),
          SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: SafeArea(
              child: Padding(
                padding: margin ?? EdgeInsets.symmetric(vertical: screenSize.height * 0.13, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (backgroundType == BackgroundType.logo || backgroundType == BackgroundType.logoWithSkip || backgroundType == BackgroundType.logoWithBackButton)
                      Row(
                        children: [
                          if (backgroundType == BackgroundType.logoWithBackButton)
                            GestureDetector(onTap: () => Navigator.pop(context), child: CustomImage(path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, size: 30)),
                          Expanded(
                            child: Align(
                              alignment: logoAlign ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
                              child: CustomImage(
                                margin: logoAlign != Alignment.center ? EdgeInsets.only(left: 16) : EdgeInsets.zero,
                                path: DefaultImages.logoWithName,
                                imageType: ImageType.svg,
                                width: screenSize.width * 0.4,
                              ),
                            ),
                          ),
                          if (backgroundType == BackgroundType.logoWithSkip)
                            if (isSkipLoading)
                              Loading(height: 30, width: 30)
                            else
                              GestureDetector(onTap: onSkipTap, child: Text(LocaleKeys.skip.tr(), style: CTextStyle.w400(fontSize: 22, color: CColors.primary, decoration: TextDecoration.underline))),
                        ],
                      ),
                    if (title != null)
                      Align(
                        alignment: titleAlignment ?? (languageDirection(context) == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight),
                        child: Padding(
                          padding: titleMargin ?? const EdgeInsets.only(top: 20),
                          child: Text(title!, textDirection: languageDirection(context), style: titleStyle ?? CTextStyle.w500(fontSize: 22)),
                        ),
                      ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
