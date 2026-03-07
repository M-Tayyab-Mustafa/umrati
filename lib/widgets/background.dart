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
            const Positioned.fill(child: _BackgroundLayer()),
            if (showEmblem) const Align(alignment: Alignment.bottomCenter, child: _EmblemOverlay()),
            Positioned.fill(
              child: SafeArea(child: Padding(padding: margin ?? context.edgeInsets(vertical: 64, horizontal: 16), child: Column(mainAxisSize: MainAxisSize.min, children: [_buildHeader(context), Expanded(child: RepaintBoundary(child: child))]))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (backgroundType == BackgroundType.titleWithBackButton) {
      return _BackButtonHeader(title: title ?? '', titleStyle: titleStyle, logoAlign: logoAlign, popConfirmationTitle: popConfirmationTitle, onPopInvokedWithResult: onPopInvokedWithResult);
    }
    return _DefaultHeader(
      backgroundType: backgroundType,
      titleType: titleType,
      title: title,
      titleWidget: titleWidget,
      titleAlignment: titleAlignment,
      titleMargin: titleMargin,
      titleStyle: titleStyle,
      logoAlign: logoAlign,
      logoMargin: logoMargin,
      skipMargin: skipMargin,
      isSkipLoading: isSkipLoading,
      onSkipTap: onSkipTap,
      popConfirmationTitle: popConfirmationTitle,
      onPopInvokedWithResult: onPopInvokedWithResult,
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/svg/background_layer.svg', fit: BoxFit.cover);
  }
}

class _EmblemOverlay extends StatelessWidget {
  const _EmblemOverlay();

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 0.15, child: CustomImage(path: 'assets/svg/emblem.svg', imageType: ImageType.svg, color: CColors.primary, height: context.h(140), width: MediaQuery.sizeOf(context).width));
  }
}

class _BackButtonHeader<T> extends StatelessWidget {
  const _BackButtonHeader({required this.title, this.titleStyle, this.logoAlign, this.popConfirmationTitle, this.onPopInvokedWithResult});

  final String title;
  final TextStyle? titleStyle;
  final Alignment? logoAlign;
  final String? popConfirmationTitle;
  final PopInvokedWithResultCallback<T>? onPopInvokedWithResult;

  Future<void> _handlePop(BuildContext context) async {
    if (onPopInvokedWithResult != null) {
      final result = await showGeneralDialog<bool>(context: context, pageBuilder: (_, _, _) => ConfirmationDialog(title: popConfirmationTitle ?? ''));
      if (result == true && context.mounted) Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(kToolbarHeight),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _handlePop(context),
            child: Transform.rotate(angle: isLTR(context) ? 0 : -(pi / 180 * 180), child: CustomImage(path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, size: context.r(25), margin: context.edgeInsets(left: 16))),
          ),
          Expanded(
            child: Padding(
              padding: context.edgeInsets(right: isLTR(context) ? 40 : 0, left: isLTR(context) ? 0 : 40),
              child: Align(alignment: logoAlign ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight), child: Text(title, textDirection: languageDirection(context), style: titleStyle ?? CTextStyle.w500(fontSize: 20))),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultHeader<T> extends StatelessWidget {
  const _DefaultHeader({
    required this.backgroundType,
    required this.titleType,
    this.title,
    this.titleWidget,
    this.titleAlignment,
    this.titleMargin,
    this.titleStyle,
    this.logoAlign,
    this.logoMargin,
    this.skipMargin,
    this.isSkipLoading = false,
    this.onSkipTap,
    this.popConfirmationTitle,
    this.onPopInvokedWithResult,
  });

  final BackgroundType backgroundType;
  final TitleType titleType;
  final String? title;
  final Widget? titleWidget;
  final Alignment? titleAlignment;
  final EdgeInsets? titleMargin;
  final TextStyle? titleStyle;
  final Alignment? logoAlign;
  final EdgeInsets? logoMargin;
  final EdgeInsets? skipMargin;
  final bool isSkipLoading;
  final VoidCallback? onSkipTap;
  final String? popConfirmationTitle;
  final PopInvokedWithResultCallback<T>? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    return Column(children: [if (backgroundType != BackgroundType.empty) _buildLogoRow(context), if (title != null || titleWidget != null) _buildTitleRow(context)]);
  }

  Widget _buildLogoRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: logoAlign ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
            child: CustomImage(margin: logoMargin ?? EdgeInsets.zero, path: DefaultImages.logoWithName, imageType: ImageType.svg, fit: BoxFit.fitWidth, width: context.r(190)),
          ),
        ),
        if (backgroundType == BackgroundType.logoWithSkip && !isSkipLoading)
          Padding(
            padding: skipMargin ?? context.edgeInsets(right: isLTR(context) ? 16 : 0, left: isLTR(context) ? 0 : 16),
            child: GestureDetector(onTap: onSkipTap, child: Text(LocaleKeys.skip.tr(), style: CTextStyle.w400(fontSize: 22, color: CColors.primary, decoration: TextDecoration.underline))),
          ),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Align(
      alignment: titleAlignment ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
      child: Padding(
        padding: titleMargin ?? context.edgeInsets(top: 20),
        child:
            titleType == TitleType.backArrow
                ? _TitleWithBackArrow<T>(title: title, titleWidget: titleWidget, titleAlignment: titleAlignment, titleStyle: titleStyle, popConfirmationTitle: popConfirmationTitle, onPopInvokedWithResult: onPopInvokedWithResult)
                : titleWidget ?? Text(title!, textDirection: languageDirection(context), style: titleStyle ?? CTextStyle.w500(fontSize: 20)),
      ),
    );
  }
}

class _TitleWithBackArrow<T> extends StatelessWidget {
  const _TitleWithBackArrow({this.title, this.titleWidget, this.titleAlignment, this.titleStyle, this.popConfirmationTitle, this.onPopInvokedWithResult});

  final String? title;
  final Widget? titleWidget;
  final Alignment? titleAlignment;
  final TextStyle? titleStyle;
  final String? popConfirmationTitle;
  final PopInvokedWithResultCallback<T>? onPopInvokedWithResult;

  Future<void> _handlePop(BuildContext context) async {
    if (onPopInvokedWithResult != null) {
      final result = await showGeneralDialog<bool>(context: context, pageBuilder: (_, _, _) => ConfirmationDialog(title: popConfirmationTitle ?? ''));
      if (result == true && context.mounted) Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: title != null ? Helper.getAlignment(context, title ?? '', titleStyle ?? CTextStyle.w500(fontSize: 20), MediaQuery.sizeOf(context).width - 32) : CrossAxisAlignment.center,
      children: [
        GestureDetector(onTap: () => _handlePop(context), child: Transform.rotate(angle: isLTR(context) ? 0 : pi / 180 * 180, child: CustomImage(path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, size: context.w(25)))),
        Expanded(
          child: Align(
            alignment: titleAlignment ?? (isLTR(context) ? Alignment.centerLeft : Alignment.centerRight),
            child: Padding(padding: context.edgeInsets(left: isLTR(context) ? 4 : 0, right: isLTR(context) ? 0 : 4), child: titleWidget ?? Text(title!, textDirection: languageDirection(context), style: titleStyle ?? CTextStyle.w500(fontSize: 18))),
          ),
        ),
      ],
    );
  }
}
