import '../export.dart';

class CheckBoxCard extends StatelessWidget {
  const CheckBoxCard({super.key, required this.title, required this.isSelected, required this.onTap, this.child, this.margin});
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? child;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      boxShadow: [],
      margin: margin ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CCheckBox(value: isSelected, onTap: onTap),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Expanded(child: Padding(padding: context.edgeInsets(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8), child: Text(title, style: CTextStyle.w600(fontSize: 16, color: CColors.primary)))),
                      // CustomImage(path: isLTR(context) ? 'assets/svg/go_forward.svg' : 'assets/svg/go_backward.svg', height: 20, width: 8, imageType: ImageType.svg),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (child != null) Padding(padding: context.edgeInsets(left: 30, right: 20), child: GestureDetector(onTap: onTap, child: child!)),
        ],
      ),
    );
  }
}
