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
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/svg/background_layer.svg',
                fit: BoxFit.cover,
              ),
            ),
            if (showEmblem)
              Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.15,
                  child: CustomImage(
                    path: 'assets/svg/emblem.svg',
                    imageType: ImageType.svg,
                    color: CColors.primary,
                    height: context.h(140),
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
              ),
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding:
                      margin ??
                      context.edgeInsets(vertical: 64, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      switch (backgroundType) {
                        BackgroundType.titleWithBackButton => SizedBox(
                          height: context.h(kToolbarHeight),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (onPopInvokedWithResult != null) {
                                    var dialogResult = await showGeneralDialog(
                                      context: context,
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => ConfirmationDialog(
                                            title: popConfirmationTitle ?? '',
                                          ),
                                    );
                                    if (dialogResult == true)
                                      Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Transform.rotate(
                                  angle: isLTR(context) ? 0 : -(pi / 180 * 180),
                                  child: CustomImage(
                                    path: 'assets/svg/arrow_backward.svg',
                                    imageType: ImageType.svg,
                                    size: context.r(25),
                                    margin: context.edgeInsets(left: 16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: context.edgeInsets(
                                    right: isLTR(context) ? 40 : 0,
                                    left: isLTR(context) ? 0 : 40,
                                  ),
                                  child: Align(
                                    alignment:
                                        logoAlign ??
                                        (isLTR(context)
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight),
                                    child: Text(
                                      title!,
                                      textDirection: languageDirection(context),
                                      style:
                                          titleStyle ??
                                          CTextStyle.w500(fontSize: 20),
                                    ),
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
                                      alignment:
                                          logoAlign ??
                                          (isLTR(context)
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight),
                                      child: CustomImage(
                                        margin: logoMargin ?? EdgeInsets.zero,
                                        path: DefaultImages.logoWithName,
                                        imageType: ImageType.svg,
                                        fit: BoxFit.fitWidth,
                                        width: context.r(190),
                                      ),
                                    ),
                                  ),
                                  if (backgroundType ==
                                      BackgroundType.logoWithSkip)
                                    if (isSkipLoading)
                                      SizedBox.shrink()
                                    else
                                      Padding(
                                        padding:
                                            skipMargin ??
                                            context.edgeInsets(
                                              right: isLTR(context) ? 16 : 0,
                                              left: isLTR(context) ? 0 : 16,
                                            ),
                                        child: GestureDetector(
                                          onTap: onSkipTap,
                                          child: Text(
                                            LocaleKeys.skip.tr(),
                                            style: CTextStyle.w400(
                                              fontSize: 22,
                                              color: CColors.primary,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            if (title != null || titleWidget != null)
                              Align(
                                alignment:
                                    titleAlignment ??
                                    (isLTR(context)
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight),
                                child: Padding(
                                  padding:
                                      titleMargin ??
                                      context.edgeInsets(top: 20),
                                  child: switch (titleType) {
                                    TitleType.empty =>
                                      titleWidget ??
                                          Text(
                                            title!,
                                            textDirection: languageDirection(
                                              context,
                                            ),
                                            style:
                                                titleStyle ??
                                                CTextStyle.w500(fontSize: 20),
                                          ),
                                    TitleType.backArrow => Row(
                                      crossAxisAlignment:
                                          title != null
                                              ? Helper.getAlignment(
                                                context,
                                                title ?? '',
                                                titleStyle ??
                                                    CTextStyle.w500(
                                                      fontSize: 20,
                                                    ),
                                                MediaQuery.sizeOf(
                                                      context,
                                                    ).width -
                                                    32,
                                              )
                                              : CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (onPopInvokedWithResult !=
                                                null) {
                                              var dialogResult =
                                                  await showGeneralDialog(
                                                    context: context,
                                                    pageBuilder:
                                                        (
                                                          context,
                                                          animation,
                                                          secondaryAnimation,
                                                        ) => ConfirmationDialog(
                                                          title:
                                                              popConfirmationTitle ??
                                                              '',
                                                        ),
                                                  );
                                              if (dialogResult == true)
                                                Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Transform.rotate(
                                            angle:
                                                isLTR(context)
                                                    ? 0
                                                    : pi / 180 * 180,
                                            child: CustomImage(
                                              path:
                                                  'assets/svg/arrow_backward.svg',
                                              imageType: ImageType.svg,
                                              size: context.w(25),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment:
                                                titleAlignment ??
                                                (isLTR(context)
                                                    ? Alignment.centerLeft
                                                    : Alignment.centerRight),
                                            child: Padding(
                                              padding: context.edgeInsets(
                                                left: isLTR(context) ? 4 : 0,
                                                right: isLTR(context) ? 0 : 4,
                                              ),
                                              child:
                                                  titleWidget ??
                                                  Text(
                                                    title!,
                                                    textDirection:
                                                        languageDirection(
                                                          context,
                                                        ),
                                                    style:
                                                        titleStyle ??
                                                        CTextStyle.w500(
                                                          fontSize: 18,
                                                        ),
                                                  ),
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
