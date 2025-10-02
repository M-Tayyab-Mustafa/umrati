// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../export.dart';
import '../utils/helper/constants.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';

class CTextField extends StatelessWidget {
  const CTextField({
    super.key,
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
  });

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
        style: style ?? CTextStyle.w500(fontSize: 13),
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          labelText: labelText == null || labelText!.isEmpty ? null : '$labelText -',
          labelStyle: labelStyle ?? CTextStyle.w500(color: CColors.primary),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          counterText: counterText ?? '',
          errorStyle: CTextStyle.w400(color: Colors.red, fontSize: 13),
          hintStyle: hintStyle ?? CTextStyle.w400(color: CColors.grey, fontSize: 13),
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

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({
    super.key,
    required this.controller,
    this.withCountryCodePicker = false,
    this.onChanged,
    this.updateSelectedCountry,
    this.margin,
    this.initialCountryCode,
    this.readOnly,
  });
  final TextEditingController controller;
  final bool withCountryCodePicker;
  final ValueChanged<String>? onChanged;
  final ValueChanged<CountryCode>? updateSelectedCountry;
  final EdgeInsets? margin;
  final bool? readOnly;
  final CountryCode? initialCountryCode;

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  int numberDigits = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      numberDigits = PhoneNumberUtil.instance.getExampleNumber(widget.initialCountryCode?.code ?? 'PK')?.nationalNumber.toString().length ?? 12;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CTextField(
      readOnly: widget.readOnly,
      labelText: LocaleKeys.number.tr(),
      margin: widget.margin ?? SizeConfig.zero,
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.phone,
      hintText: LocaleKeys.your_number_here.tr(),
      inputFormatters: [UsPhoneNumberFormatter()],
      maxLength: numberDigits + 1,
      prefixMargin: SizeConfig.only(left: 16, top: 0),
      suffixMargin: SizeConfig.only(left: 16, top: 0),
      textDirection: TextDirection.ltr,
      prefixIcon: widget.withCountryCodePicker && isLTR(context) ? _countryCodePicker : null,
      suffixIcon: widget.withCountryCodePicker && !isLTR(context) ? _countryCodePicker : null,
    );
  }

  Widget get _countryCodePicker => Directionality(
    textDirection: TextDirection.ltr,
    child: CountryCodePicker(
      onChanged: widget.updateSelectedCountry,
      initialSelection: 'PK',
      favorite: ['+92', 'PK'],
      builder: (countryCode) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImage(path: 'assets/png/${countryCode!.flagUri!}', imageType: ImageType.png, size: SizeConfig.w(25)),
            Padding(padding: SizeConfig.only(left: 12), child: CustomImage(path: 'assets/svg/arrow_down.svg', imageType: ImageType.svg, height: SizeConfig.h(6), width: SizeConfig.w(15))),
            Padding(padding: SizeConfig.only(left: 4), child: Text(countryCode.dialCode!, style: CTextStyle.w500(fontSize: 13, color: CColors.greyShade1))),
          ],
        );
      },
    ),
  );
}
