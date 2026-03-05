import '../export.dart';

class ZiaraatCityCard extends StatelessWidget {
  const ZiaraatCityCard({super.key, required this.icon, required this.title, this.isSelected = false, required this.onTap});
  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      onTap: onTap,
      boxShadow: isSelected ? null : [],
      borderColor: isSelected ? null : CColors.greyShade2,
      borderWidth: context.w(3),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomImage(margin: context.edgeInsets(bottom: 10), path: icon, size: constraints.maxHeight, imageType: ImageType.svg, fit: BoxFit.fitHeight, color: isSelected ? CColors.primary : CColors.greyShade2);
              },
            ),
          ),
          Text(title, style: CTextStyle.w500(fontSize: 20, color: isSelected ? CColors.primary : CColors.greyShade2)),
        ],
      ),
    );
  }
}
