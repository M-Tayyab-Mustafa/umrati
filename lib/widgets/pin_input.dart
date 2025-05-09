import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../utils/helper/constants.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';

class PinInput extends StatelessWidget {
  const PinInput({super.key, required this.controller, this.margin});
  final TextEditingController controller;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Pinput(
        length: 6,
        defaultPinTheme: PinTheme(
          margin: EdgeInsets.only(right: 2),
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            border: Border.all(color: CColors.primary, width: 2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: primaryShadows.map((e) => e.copyWith(color: e.color.withValues(alpha: 0.2))).toList(),
          ),
          textStyle: CTextStyle.w500(),
        ),
        showCursor: true,
        keyboardType: TextInputType.number,
        controller: controller,
      ),
    );
  }
}
