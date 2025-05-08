import 'package:flutter/material.dart';

import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../card.dart';
import '../custom_image.dart';

class ZiaratCityCard extends StatelessWidget {
  const ZiaratCityCard({super.key, required this.icon, required this.title, this.isSelected = false, required this.onTap});
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
      borderWidth: 3,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomImage(
                  margin: EdgeInsets.only(bottom: 10),
                  path: icon,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  imageType: ImageType.svg,
                  fit: BoxFit.fill,
                  color: isSelected ? CColors.primary : CColors.greyShade2,
                );
              },
            ),
          ),
          Expanded(child: Text(title, style: CTextStyle.w500(fontSize: 26, color: isSelected ? CColors.primary : CColors.greyShade2))),
        ],
      ),
    );
  }
}
