import 'package:flutter/material.dart';

import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';

class ZiaratMarker extends StatelessWidget {
  const ZiaratMarker({super.key, this.size = 50, required this.title, required this.distance});
  final double size;
  final String title;
  final String distance;

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
            decoration: BoxDecoration(color: CColors.primary, borderRadius: BorderRadius.circular(3)),
            child: Row(
              children: [Expanded(child: Text(title, style: CTextStyle.w500(color: Colors.white), maxLines: 1)), Text('$distance Km', style: CTextStyle.w500(color: Colors.white), maxLines: 1)],
            ),
          ),
        ),
      ],
    );
  }
}
