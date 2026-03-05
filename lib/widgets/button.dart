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
    final buttonFontSize = fontSize ?? 13;
    final double buttonSize = title != null ? Helper.getTextSize(title!, style ?? CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: buttonFontSize)).width + context.r(50) + (titleWithIcon ? (iconSize ?? 25).r : 0) : 0;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: !isEnabled || isLoading ? null : onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: context.h(height ?? 40),
            maxHeight: context.h(height ?? 45),
            minWidth: width?.w ?? (useTitleWidth ? (32 + buttonSize).w : 180.w),
            maxWidth: width?.w ?? (useTitleWidth ? (32 + buttonSize).w : (buttonSize < 180 ? 180 : buttonSize + 20).w),
          ),
          child: Container(
            padding: padding ?? context.edgeInsets(horizontal: 20),
            decoration: BoxDecoration(
              shape: shape ?? BoxShape.rectangle,
              border: Border.all(color: borderColor ?? CColors.primary, width: 1),
              boxShadow: shadows ?? [...primaryShadows, BoxShadow(color: CColors.buttonShadow, offset: Offset(0, 6), blurRadius: 6)],
              color: isEnabled ? backgroundColor : Colors.grey,
              gradient: isEnabled && backgroundColor == null ? gradient ?? CColors.buttonGradient : null,
              borderRadius: shape == BoxShape.circle ? null : borderRadius ?? BorderRadius.circular(16),
            ),
            child:
                isLoading
                    ? Loading(height: context.r(30), width: context.r(30), color: Colors.white)
                    : title != null
                    ? titleWithIcon
                        ? Directionality(
                          textDirection: textDirection ?? (isLTR(context) ? TextDirection.ltr : TextDirection.rtl),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(title!, style: style ?? CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: buttonFontSize), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Transform.rotate(angle: isLTR(context) ? 0 : pi / 180 * 180, child: CustomImage(margin: context.edgeInsets(left: 12), path: DefaultImages.longArrowForward, imageType: ImageType.svg, width: context.w(iconSize ?? 24))),
                            ],
                          ),
                        )
                        : Align(alignment: Alignment.center, child: Text(title!, style: style ?? CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: buttonFontSize), maxLines: 1, overflow: TextOverflow.ellipsis))
                    : child!,
          ),
        ),
      ),
    );
  }
}
