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
  });

  double get _buttonSize => 50;
  final String title;
  final String? iconPath;
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
          height: height ?? _buttonSize,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(color: backgroundColor ?? Colors.black, borderRadius: BorderRadius.circular(cornersRadius ?? 10)),
          child:
              isLoading
                  ? Loading()
                  : Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Displays Google logo using SVG
                        if (iconPath != null) CustomImage(path: iconPath!, height: (height ?? _buttonSize) * 0.9, width: (height ?? _buttonSize) * 0.45, imageType: iconType ?? ImageType.svg),
                        // Adds space between logo and text
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(title, style: TextStyle(color: Colors.white, fontSize: (height ?? _buttonSize) * 0.3, fontWeight: FontWeight.w600, letterSpacing: 0.7)),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
