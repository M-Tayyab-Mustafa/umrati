import '../export.dart';

class CButton extends StatelessWidget {
  const CButton({
    super.key,
    this.title,
    this.child,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.useTitleWidth = false,
    this.fontSize,
    this.iconSize,
    this.style,
    this.borderRadius,
    this.borderColor,
    this.isLoading = false,
    this.titleWithIcon = false,
    this.onTap,
    this.isEnabled = true,
    this.gradient,
    this.shape,
    this.titleColor,
    this.shadows,
    this.backgroundColor,
    this.textDirection,
  }) : assert((title != null) ^ (child != null), 'Must contain either title or child, but not both.');

  final Color? borderColor;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? iconSize;
  final BorderRadiusGeometry? borderRadius;
  final String? title;
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final TextStyle? style;
  final bool isLoading;
  final bool useTitleWidth;
  final bool titleWithIcon;
  final GestureTapCallback? onTap;
  final TextDirection? textDirection;
  final bool isEnabled;
  final Gradient? gradient;
  final BoxShape? shape;
  final Color? titleColor;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? 13;
    final effectiveStyle = style ?? CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: effectiveFontSize);

    final double titleWidth = title != null ? Helper.getTextSize(title!, effectiveStyle).width + context.r(50) + (titleWithIcon ? (iconSize ?? 25).r : 0) : 0;

    final double minW = width?.w ?? (useTitleWidth ? (32 + titleWidth).w : 180.w);
    final double maxW = width?.w ?? (useTitleWidth ? (32 + titleWidth).w : (titleWidth < 180 ? 180 : titleWidth + 20).w);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: (!isEnabled || isLoading) ? null : onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.h(height ?? 40), maxHeight: context.h(height ?? 45), minWidth: minW, maxWidth: maxW),
          child: Container(
            padding: padding ?? context.edgeInsets(horizontal: 20),
            decoration: BoxDecoration(
              shape: shape ?? BoxShape.rectangle,
              border: Border.all(color: borderColor ?? CColors.primary, width: 1),
              boxShadow: shadows ?? [...primaryShadows, BoxShadow(color: CColors.buttonShadow, offset: const Offset(0, 6), blurRadius: 6)],
              color: isEnabled ? backgroundColor : Colors.grey,
              gradient: isEnabled && backgroundColor == null ? gradient ?? CColors.buttonGradient : null,
              borderRadius: shape == BoxShape.circle ? null : borderRadius ?? BorderRadius.circular(16),
            ),
            child: _buildChild(context, effectiveFontSize, effectiveStyle),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context, double effectiveFontSize, TextStyle effectiveStyle) {
    if (isLoading) {
      return Loading(height: context.r(30), width: context.r(30), color: Colors.white);
    }
    if (title != null) {
      return titleWithIcon ? _TitleWithIcon(title: title!, style: effectiveStyle, iconSize: iconSize, textDirection: textDirection) : _TitleOnly(title: title!, style: effectiveStyle);
    }
    return child!;
  }
}

class _TitleOnly extends StatelessWidget {
  const _TitleOnly({required this.title, required this.style});
  final String title;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: Text(title, style: style, maxLines: 1, overflow: TextOverflow.ellipsis));
  }
}

class _TitleWithIcon extends StatelessWidget {
  const _TitleWithIcon({required this.title, required this.style, this.iconSize, this.textDirection});
  final String title;
  final TextStyle style;
  final double? iconSize;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection ?? (isLTR(context) ? TextDirection.ltr : TextDirection.rtl),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
          Transform.rotate(angle: isLTR(context) ? 0 : pi / 180 * 180, child: CustomImage(margin: context.edgeInsets(left: 12), path: DefaultImages.longArrowForward, imageType: ImageType.svg, width: context.w(iconSize ?? 24))),
        ],
      ),
    );
  }
}
