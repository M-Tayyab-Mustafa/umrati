import '../export.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({super.key, required this.icon, required this.title, required this.onTap, required this.isSelected});
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage(path: icon, imageType: ImageType.svg, height: 25.pr, width: 15.pr, fit: BoxFit.scaleDown, color: isSelected ? CColors.primary : CColors.deepTeal),
            Text(title, style: CTextStyle.w400(color: isSelected ? CColors.primary : CColors.deepTeal, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
