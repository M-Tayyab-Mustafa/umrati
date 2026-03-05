import '../export.dart';

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
    this.onTap,
    this.alignment = Alignment.center,
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
  final VoidCallback? onTap;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        height: height,
        width: width,
        alignment: alignment,
        padding: padding ?? context.edgeInsets(all: 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? (backgroundGradient != null ? null : Colors.transparent),
          gradient: backgroundGradient,
          border: Border.all(color: borderColor ?? CColors.primary, width: context.w(borderWidth ?? 2)),
          borderRadius: BorderRadius.circular(context.r(borderRadius ?? 16)),
          boxShadow: boxShadow ?? primaryShadows,
        ),
        child: child,
      ),
    );
  }
}
