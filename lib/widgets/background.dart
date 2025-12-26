import '../export.dart';

class Background<T> extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
    this.backgroundType = BackgroundType.empty,
    this.titleType = TitleType.empty,
    this.margin,
    this.title,
    this.titleAlignment,
    this.logoAlign,
    this.onSkipTap,
    this.titleMargin,
    this.logoMargin,
    this.titleStyle,
    this.showEmblem = true,
    this.isSkipLoading = false,
    this.skipMargin,
    this.titleWidget,
    this.resizeToAvoidBottomInset = false,
    this.canPop,
    this.onPopInvokedWithResult,
    this.popConfirmationTitle,
  });
  final Widget child;
  final BackgroundType backgroundType;
  final TitleType titleType;
  final String? title;
  final Widget? titleWidget;
  final Alignment? titleAlignment;
  final Alignment? logoAlign;
  final VoidCallback? onSkipTap;
  final EdgeInsets? margin;
  final EdgeInsets? titleMargin;
  final EdgeInsets? skipMargin;
  final EdgeInsets? logoMargin;
  final TextStyle? titleStyle;
  final bool showEmblem;
  final bool isSkipLoading;
  final bool resizeToAvoidBottomInset;
  final bool? canPop;
  final PopInvokedWithResultCallback<T>? onPopInvokedWithResult;
  final String? popConfirmationTitle;
  @override
  Widget build(BuildContext context) {
    return PopScope<T>(
      canPop: canPop ?? true,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Stack(
          children: [
            // Opacity(opacity: 0.1, child: CustomImage(path: 'assets/png/background.png', imageType: ImageType.png, height: SizeConfig.screenHeight, width: SizeConfig.screenWidth, fit: BoxFit.fill)),
            // Container(
            //   height: SizeConfig.screenHeight,
            //   width: SizeConfig.screenWidth,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [Color(0x73737300).withValues(alpha: 0.05), Color.fromARGB(255, 168, 255, 178).withValues(alpha: 0.25)],
            //       stops: [0.3, 1],
            //       begin: Alignment.centerLeft,
            //       end: Alignment.centerRight,
            //     ),
            //   ),
            // ),
            CustomImage(path: 'assets/svg/background_layer.svg', imageType: ImageType.svg, height: SizeConfig.mediaQuery.size.height, width: SizeConfig.mediaQuery.size.width, fit: BoxFit.fill),
            // Opacity(
            //   opacity: 0.6,
            //   child: CustomImage(
            //     path: 'assets/svg/islamic_pattern.svg',
            //     imageType: ImageType.svg,
            //     fit: BoxFit.cover,
            // height: SizeConfig.mediaQuery.size.height,
            // width: SizeConfig.mediaQuery.size.width,
            //     color: Colors.white,
            //   ),
            // ),
            // Opacity(opacity: 0.3, child: CustomImage(path: 'assets/svg/modal.svg', imageType: ImageType.svg, fit: BoxFit.cover, height: SizeConfig.mediaQuery.size.height, width: SizeConfig.mediaQuery.size.width)),
            if (showEmblem)
              Align(alignment: Alignment.bottomCenter, child: Opacity(opacity: 0.15, child: CustomImage(path: 'assets/svg/emblem.svg', imageType: ImageType.svg, color: CColors.primary, height: 190.pr, width: SizeConfig.mediaQuery.size.width))),
            SizedBox(
              height: SizeConfig.mediaQuery.size.height,
              width: SizeConfig.mediaQuery.size.width,
              child: SafeArea(
                child: Padding(
                  padding: margin ?? ScaledEdgeInsets.symmetric(vertical: 64, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      switch (backgroundType) {
                        BackgroundType.titleWithBackButton => SizedBox(
                          height: kToolbarHeight.pr,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (onPopInvokedWithResult != null) {
                                    var dialogResult = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: popConfirmationTitle ?? ''));
                                    if (dialogResult == true) Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Transform.rotate(angle: isLTR(context) ? 0 : -(pi / 180 * 180), child: CustomImage(path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, size: 25.pr, margin: ScaledEdgeInsets.only(left: 16))),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: ScaledEdgeInsets.only(right: isLTR(context) ? 40 : 0, left: isLTR(context) ? 0 : 40),
                                  child: Align(
                                    alignment: logoAlign ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
                                    child: Text(title!, textDirection: languageDirection(context), style: titleStyle ?? CTextStyle.w500(fontSize: 20)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _ => Column(
                          children: [
                            if (backgroundType != BackgroundType.empty)
                              Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: logoAlign ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
                                      child: CustomImage(margin: logoMargin ?? ScaledEdgeInsets.zero, path: DefaultImages.logoWithName, imageType: ImageType.svg, fit: BoxFit.fitWidth, width: (SizeConfig.mediaQuery.size.width * 0.45).pr),
                                    ),
                                  ),
                                  if (backgroundType == BackgroundType.logoWithSkip)
                                    if (isSkipLoading)
                                      SizedBox.shrink()
                                    else
                                      Padding(
                                        padding: skipMargin ?? ScaledEdgeInsets.only(right: isLTR(context) ? 16 : 0, left: isLTR(context) ? 0 : 16),
                                        child: GestureDetector(onTap: onSkipTap, child: Text(LocaleKeys.skip.tr(), style: CTextStyle.w400(fontSize: 20, color: CColors.primary, decoration: TextDecoration.underline))),
                                      ),
                                ],
                              ),
                            if (title != null || titleWidget != null)
                              Align(
                                alignment: titleAlignment ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
                                child: Padding(
                                  padding: titleMargin ?? ScaledEdgeInsets.only(top: 20),
                                  child: switch (titleType) {
                                    TitleType.empty => titleWidget ?? Text(title!, textDirection: languageDirection(context), style: titleStyle ?? CTextStyle.w500(fontSize: 18)),
                                    TitleType.backArrow => Row(
                                      crossAxisAlignment: title != null ? Helper.getAlignment(context, title ?? '', titleStyle ?? CTextStyle.w500(fontSize: isLTR(context) ? 18 : 22), SizeConfig.mediaQuery.size.width - 32) : CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (onPopInvokedWithResult != null) {
                                              var dialogResult = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: popConfirmationTitle ?? ''));
                                              if (dialogResult == true) Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Transform.rotate(angle: isLTR(context) ? 0 : pi / 180 * 180, child: CustomImage(path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, size: 30)),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: titleAlignment ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
                                            child: Padding(
                                              padding: ScaledEdgeInsets.only(left: isLTR(context) ? 4 : 0, right: isLTR(context) ? 0 : 4),
                                              child: titleWidget ?? Text(title!, textDirection: languageDirection(context), style: titleStyle ?? CTextStyle.w500(fontSize: 18)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  },
                                ),
                              ),
                          ],
                        ),
                      },
                      Expanded(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
