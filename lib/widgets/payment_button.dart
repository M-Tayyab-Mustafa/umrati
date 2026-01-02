import '../export.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.title,
    this.isLoading = false,
    this.iconPath,
    this.iconType,
    this.height,
    this.width,
    this.cornersRadius,
    this.backgroundColor,
    this.onTap,
    this.margin,
    this.icon,
    this.iconBackgroundColor,
    this.iconPadding,
  });

  double get _buttonSize => 40;
  final String title;
  final Widget? icon;
  final String? iconPath;
  final EdgeInsets? iconPadding;
  final Color? iconBackgroundColor;
  final ImageType? iconType;
  final double? height;
  final double? width;
  final double? cornersRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: isLoading ? () {} : onTap,
        child: Container(
          // Dimensions and padding of the button
          height: height?.pr ?? _buttonSize.pr,
          width: width?.pr,
          padding: ScaledEdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: backgroundColor ?? Colors.black, borderRadius: BorderRadius.circular(cornersRadius?.pr ?? 10.pr)),
          child:
              isLoading
                  ? Loading()
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (iconPath != null || icon != null)
                        Container(
                          padding: iconPadding ?? EdgeInsets.zero,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: iconBackgroundColor ?? Colors.transparent),
                          height: 22.pr,
                          width: 22.pr,
                          child: FittedBox(child: icon != null ? icon! : CustomImage(path: iconPath!, imageType: iconType ?? ImageType.svg)),
                        ),
                      Padding(padding: ScaledEdgeInsets.only(left: 10), child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600, letterSpacing: 0.5.sp, wordSpacing: 1.sp))),
                    ],
                  ),
        ),
      ),
    );
  }
}
