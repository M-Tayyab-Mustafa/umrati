import 'package:flutter/material.dart';

import '../utils/helper/constants.dart';
import '../utils/theme/colors.dart';

class CCheckBox extends StatelessWidget {
  const CCheckBox({
    super.key,
    this.size = 20,
    required this.value,
    this.borderWidth,
    this.borderRadius,
    this.checkColor,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.inactiveBorderColor,
    this.enabledShadow = false,
    this.onTap,
  });
  final bool value;
  final bool enabledShadow;
  final double size;
  final VoidCallback? onTap;
  final double? borderWidth;
  final double? borderRadius;
  final Color? checkColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? borderColor;
  final Color? inactiveBorderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? (size / 4.5)),
          border: Border.all(color: borderColor ?? CColors.primary, width: borderWidth ?? 2),
          boxShadow: enabledShadow ? primaryShadows : null,
          color: value ? activeColor ?? CColors.primary.withValues(alpha: 0.8) : inactiveColor ?? Colors.transparent,
        ),
        height: size,
        width: size,
        child: value ? FittedBox(child: Center(child: Icon(Icons.check, color: checkColor ?? Colors.white))) : const SizedBox.shrink(),
      ),
    );
  }
}
