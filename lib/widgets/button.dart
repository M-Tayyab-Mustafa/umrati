import '../export.dart';

class CButton extends StatelessWidget {
  const CButton({
    super.key,
    this.title,
    this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
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
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  final BorderRadiusGeometry? borderRadius;
  final String? title;
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final TextStyle? style;
  final bool isLoading;
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
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: !isEnabled || isLoading ? null : onTap,
        child: Container(
          height: SizeConfig.h(height ?? 50),
          width: width != null ? SizeConfig.w(width!) : null,
          padding: padding ?? SizeConfig.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            shape: shape ?? BoxShape.rectangle,
            border: Border.all(color: borderColor ?? CColors.primary, width: 1),
            boxShadow: shadows ?? [...primaryShadows, BoxShadow(color: CColors.buttonShadow, offset: Offset(0, 6), blurRadius: 6)],
            color: isEnabled ? backgroundColor : Colors.grey,
            gradient: isEnabled ? gradient ?? CColors.buttonGradient : null,
            borderRadius: shape == BoxShape.circle ? null : borderRadius ?? BorderRadius.circular(16),
          ),
          child:
              isLoading
                  ? LayoutBuilder(builder: (context, constraints) => Loading(height: SizeConfig.h(constraints.maxHeight * 0.6), width: SizeConfig.h(constraints.maxHeight * 0.6), color: Colors.white))
                  : title != null
                  ? titleWithIcon
                      ? Directionality(
                        textDirection: textDirection ?? (isLTR(context) ? TextDirection.ltr : TextDirection.rtl),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(title!, style: CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: SizeConfig.sp(fontSize ?? 13)), maxLines: 1),
                            Transform.rotate(
                              angle: isLTR(context) ? 0 : pi / 180 * 180,
                              child: CustomImage(margin: SizeConfig.only(left: 12), path: DefaultImages.longArrowForward, imageType: ImageType.svg, width: SizeConfig.w(iconSize ?? 25)),
                            ),
                          ],
                        ),
                      )
                      : Align(
                        alignment: Alignment.center,
                        child: Text(title!, style: style ?? CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: SizeConfig.sp(fontSize ?? 13)), maxLines: 1, overflow: TextOverflow.ellipsis),
                      )
                  : child!,
        ),
      ),
    );
  }
}
