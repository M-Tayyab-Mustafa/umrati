import 'package:flutter/material.dart';

import '../utils/helper/constants.dart';
import '../utils/theme/colors.dart';

class BasicCard extends StatelessWidget {
  const BasicCard({
    super.key,
    this.margin,
    this.padding,
    this.height,
    this.width,
    required this.child,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
  });
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final Widget child;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      height: height,
      width: width,
      padding: padding ?? EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        gradient: backgroundGradient,
        border: Border.all(color: borderColor ?? CColors.primary, width: borderWidth ?? 2),
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: boxShadow ?? primaryShadows,
      ),
      child: child,
    );
  }
}
