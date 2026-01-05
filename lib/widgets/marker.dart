import '../export.dart';

class CMarker extends StatelessWidget {
  const CMarker({super.key, this.size = 50, required this.title, this.distance, this.color, this.indicatorColor, this.titleColor, this.textDirection});
  final double size;
  final String title;
  final String? distance;
  final Color? color;
  final Color? indicatorColor;
  final Color? titleColor;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: size,
          width: context.w(20),
          child: Stack(
            children: [
              Center(child: Container(width: context.w(2), decoration: BoxDecoration(color: indicatorColor ?? CColors.primary))),
              Center(child: Container(width: context.w(12), decoration: BoxDecoration(color: indicatorColor ?? CColors.primary, shape: BoxShape.circle))),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: context.h(size / 1.5),
            padding: context.edgeInsets(horizontal: 8),
            decoration: BoxDecoration(color: color ?? CColors.primary, borderRadius: BorderRadius.circular(context.r(3))),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: CTextStyle.w400(color: titleColor ?? Colors.white, fontSize: 14), maxLines: 1, textDirection: textDirection ?? languageDirection(context), textAlign: isLTR(context) ? TextAlign.left : TextAlign.right),
                ),
                if (distance != null) Directionality(textDirection: TextDirection.ltr, child: Text('$distance Km', style: CTextStyle.w400(color: Colors.white, fontSize: 14), maxLines: 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
