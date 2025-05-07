import 'package:flutter/material.dart';

import 'custom_image.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImage(path: icon, imageType: ImageType.svg, height: 18, width: 18, fit: BoxFit.scaleDown, color: isSelected ? CColors.primary : CColors.deepTeal),
          Text(title, style: CTextStyle.w400(color: isSelected ? CColors.primary : CColors.deepTeal, fontSize: 9)),
        ],
      ),
    );
  }
}
