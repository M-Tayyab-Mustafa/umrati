import '../export.dart';

class CListTile extends ConsumerWidget {
  const CListTile({super.key, this.child, this.icon, this.iconSize, this.iconType, this.title, this.margin, this.padding, this.onTap, this.borderRadius, this.trailing})
    : assert((title != null) ^ (child != null), 'Must contain either title or child, but not both.');
  final Widget? child;
  final Widget? trailing;
  final String? icon;
  final double? iconSize;
  final ImageType? iconType;
  final String? title;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicCard(
      borderWidth: 3,
      onTap: onTap,
      margin: margin ?? EdgeInsets.only(bottom: 22, left: screenSize.width * 0.06, right: screenSize.width * 0.06),
      padding: padding,
      borderRadius: borderRadius ?? 8,
      backgroundColor: CColors.tileBackground,
      boxShadow: [BoxShadow(color: CColors.greyShade4, blurRadius: 5, offset: Offset(0, 2))],
      borderColor: CColors.greyShade4,
      child: switch (child) {
        null => Row(
          children: [
            if (icon != null)
              CustomImage(
                margin: EdgeInsets.only(right: isLTR(context) ? 10 : 0, left: isLTR(context) ? 0 : 10),
                path: icon!,
                imageType: iconType ?? ImageType.svg,
                size: iconSize ?? 25,
                color: CColors.deepTeal,
              ),
            Expanded(child: Text(title!, style: CTextStyle.w600(color: CColors.deepTeal, fontSize: 22))),
            if (trailing != null) trailing!,
          ],
        ),
        _ => child!,
      },
    );
  }
}
