import '../export.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.image, required this.title, required this.description, required this.onTap, this.margin});
  final String image;
  final String title;
  final String description;
  final VoidCallback onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      onTap: onTap,
      margin: margin,
      child: Row(
        children: [
          CustomImage(path: image, imageType: ImageType.png, size: 100, margin: EdgeInsets.only(right: 16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(title, style: CTextStyle.w500(fontSize: 24, color: CColors.deepTeal), maxLines: 2, overflow: TextOverflow.ellipsis),
                  CustomImage(margin: EdgeInsets.only(left: 16), path: DefaultImages.longArrowForward, imageType: ImageType.svg, width: 35, color: CColors.deepTeal),
                ],
              ),
              Text(description, style: CTextStyle.w500(color: CColors.deepTeal, fontSize: 18), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}
