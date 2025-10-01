// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/helper/constants.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';

class CTextField extends StatelessWidget {
  const CTextField({
    Key? key,
    this.controller,
    this.margin,
    this.hintText = '',
    this.labelText = '',
    this.isDense = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType = TextInputType.name,
    this.obscureText = false,
    this.enabled,
    this.readOnly,
    this.onTap,
    this.hintStyle,
    this.labelStyle,
    this.style,
    this.fillColor,
    this.prefixIcon,
    this.prefixMargin,
    this.suffixIcon,
    this.suffixMargin,
    this.counterText,
    this.borderRadius,
    this.inputFormatters,
    this.onPrefixTap,
    this.onSuffixTap,
    this.borderColor,
    this.boxShadow,
    this.focusNode,
    this.textDirection,
  }) : super(key: key);

  final TextEditingController? controller;
  final EdgeInsets? margin;
  final String hintText;
  final String? labelText;
  final bool isDense;
  final int maxLines;
  final int? maxLength;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged? onFieldSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? enabled;
  final bool? readOnly;
  final VoidCallback? onTap;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final Color? fillColor;
  final Widget? prefixIcon;
  final EdgeInsets? prefixMargin;
  final Widget? suffixIcon;
  final EdgeInsets? suffixMargin;
  final String? counterText;
  final double? borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final GestureTapCallback? onPrefixTap;
  final GestureTapCallback? onSuffixTap;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final FocusNode? focusNode;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(boxShadow: boxShadow ?? primaryShadows, borderRadius: BorderRadius.circular(borderRadius ?? 10.0)),
      child: TextFormField(
        textDirection: textDirection,
        focusNode: focusNode,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        onChanged: onChanged,
        cursorColor: CColors.primary,
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly ?? false,
        onTap: onTap,
        inputFormatters: inputFormatters,
        style: style ?? CTextStyle.w500(fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          labelText: labelText == null || labelText!.isEmpty ? null : '$labelText -',
          labelStyle: labelStyle ?? CTextStyle.w500(color: CColors.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          counterText: counterText ?? '',
          errorStyle: CTextStyle.w400(color: Colors.red),
          hintStyle: hintStyle ?? CTextStyle.w400(color: CColors.grey),
          isDense: isDense,
          fillColor: fillColor ?? Colors.transparent,
          enabledBorder: _getBorder(borderColor, borderRadius),
          focusedBorder: _getBorder(borderColor, borderRadius),
          disabledBorder: _getBorder(borderColor, borderRadius),
          errorBorder: _getBorder(borderColor, borderRadius),
          focusedErrorBorder: _getBorder(borderColor, borderRadius),
          border: _getBorder(borderColor ?? Colors.transparent, borderRadius),
          prefixIcon: prefixIcon != null ? Padding(padding: prefixMargin ?? EdgeInsets.zero, child: GestureDetector(onTap: onPrefixTap, child: prefixIcon)) : null,
          suffixIcon: suffixIcon != null ? Padding(padding: suffixMargin ?? EdgeInsets.zero, child: GestureDetector(onTap: onSuffixTap, child: suffixIcon)) : null,
        ),
      ),
    );
  }

  OutlineInputBorder _getBorder(Color? color, double? borderRadius) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius ?? 10.0), borderSide: BorderSide(color: color ?? CColors.primary, width: 2.0));
  }
}
