import 'package:flutter/material.dart';

import '../utils/helper/constants.dart';
import '../utils/theme/colors.dart';

class CCheckBox extends StatelessWidget {
  const CCheckBox({super.key, this.size = 20, required this.value});
  final double size;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 4.5),
        border: Border.all(color: CColors.primary, width: 2),
        boxShadow: primaryShadows,
        color: value ? CColors.primary.withValues(alpha: 0.8) : Colors.transparent,
      ),
      height: size,
      width: size,
      child: value ? FittedBox(child: Center(child: Icon(Icons.check, color: Colors.white))) : const SizedBox.shrink(),
    );
  }
}
