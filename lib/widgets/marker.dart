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
          width: 20.pr,
          child: Stack(
            children: [
              Center(child: Container(width: 2.pr, decoration: BoxDecoration(color: indicatorColor ?? CColors.primary))),
              Center(child: Container(width: 12.pr, decoration: BoxDecoration(color: indicatorColor ?? CColors.primary, shape: BoxShape.circle))),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: (size / 1.5).pr,
            padding: ScaledEdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: color ?? CColors.primary, borderRadius: BorderRadius.circular(3.pr)),
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
