import '../export.dart';

class CMarker extends StatelessWidget {
  const CMarker({super.key, this.size = 50, required this.title, this.distance, this.color, this.titleColor, this.textDirection});
  final double size;
  final String title;
  final String? distance;
  final Color? color;
  final Color? titleColor;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: size,
          width: 20,
          child: Stack(
            children: [
              Center(child: Container(width: 2, decoration: BoxDecoration(color: CColors.primary))),
              Center(child: Container(width: 15, decoration: BoxDecoration(color: CColors.primary, shape: BoxShape.circle))),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: size / 1.5,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: color ?? CColors.primary, borderRadius: BorderRadius.circular(3)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: CTextStyle.w500(color: titleColor ?? Colors.white),
                    maxLines: 1,
                    textDirection: textDirection ?? languageDirection(context),
                    textAlign: isLTR(context) ? TextAlign.left : TextAlign.right,
                  ),
                ),
                if (distance != null) Directionality(textDirection: TextDirection.ltr, child: Text('$distance Km', style: CTextStyle.w500(color: Colors.white), maxLines: 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
