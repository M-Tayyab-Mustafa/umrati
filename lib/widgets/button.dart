import 'package:flutter/material.dart';
import 'package:umrati/utils/helper/constants.dart';
import 'package:umrati/widgets/custom_image.dart';

import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import 'loading.dart';

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
  }) : assert((title != null) ^ (child != null), 'Must contain either title or child, but not both.');

  final Color? borderColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;
  final String? title;
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final TextStyle? style;
  final bool isLoading;
  final bool titleWithIcon;
  final GestureTapCallback? onTap;
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
          height: height ?? 60,
          width: width,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            shape: shape ?? BoxShape.rectangle,
            border: Border.all(color: borderColor ?? CColors.primary, width: 1),
            boxShadow: shadows ?? [...primaryShadows, BoxShadow(color: CColors.buttonShadow, offset: Offset(0, 6), blurRadius: 6)],
            color: isEnabled ? null : Colors.grey,
            gradient: isEnabled ? gradient ?? CColors.buttonGradient : null,
            borderRadius: shape == BoxShape.circle ? null : borderRadius ?? BorderRadius.circular(16),
          ),
          child:
              isLoading
                  ? LayoutBuilder(builder: (context, constraints) => Loading(height: constraints.maxHeight * 0.6, width: constraints.maxHeight * 0.6, color: Colors.white))
                  : title != null
                  ? titleWithIcon
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(title!, style: CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: fontSize ?? 17), maxLines: 1),
                          CustomImage(margin: EdgeInsets.only(left: 16), path: DefaultImages.longArrowForward, imageType: ImageType.svg, width: 35),
                        ],
                      )
                      : Align(
                        alignment: Alignment.center,
                        child: Text(title!, style: style ?? CTextStyle.w500(color: titleColor ?? Colors.white, fontSize: fontSize ?? 17), maxLines: 1, overflow: TextOverflow.ellipsis),
                      )
                  : child!,
        ),
      ),
    );
  }
}
