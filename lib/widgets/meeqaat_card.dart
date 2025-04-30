import 'package:flutter/material.dart';

import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import 'card.dart';
import 'check_box.dart';
import 'custom_image.dart';

class MeeqaatCard extends StatelessWidget {
  const MeeqaatCard({super.key, required this.title, required this.isSelected, required this.onTap, this.child, this.margin});
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
        children: [
          Row(
            children: [
              CCheckBox(value: isSelected),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Expanded(child: Padding(padding: const EdgeInsets.only(left: 10), child: Text(title, style: CTextStyle.w600(fontSize: 16, color: CColors.primary)))),
                      const CustomImage(path: 'assets/svg/arrow_forward.svg', height: 20, width: 8, imageType: ImageType.svg),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (child != null) Padding(padding: const EdgeInsets.only(left: 30, right: 20), child: GestureDetector(onTap: onTap, child: child!)),
        ],
      ),
    );
  }
}
