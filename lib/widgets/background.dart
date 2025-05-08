import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../utils/helper/constants.dart';
import '../utils/services/translations/locale_keys.g.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import 'custom_image.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
    this.backgroundType = BackgroundType.empty,
    this.margin,
    this.title,
    this.titleAlignment = Alignment.centerLeft,
    this.logoAlign = MainAxisAlignment.spaceBetween,
    this.onSkipTap,
    this.titleMargin,
    this.titleStyle,
    this.showEmblem = true,
  });
  final Widget child;
  final BackgroundType backgroundType;
  final String? title;
  final Alignment titleAlignment;
  final MainAxisAlignment logoAlign;
  final VoidCallback? onSkipTap;
  final EdgeInsets? margin;
  final EdgeInsets? titleMargin;
  final TextStyle? titleStyle;
  final bool showEmblem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Opacity(opacity: 0.1, child: CustomImage(path: 'assets/png/background.png', imageType: ImageType.png, height: screenSize.height, width: screenSize.width, fit: BoxFit.fill)),
          Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x73737300).withValues(alpha: 0.05), Color.fromARGB(255, 168, 255, 178).withValues(alpha: 0.25)],
                stops: [0.3, 1],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: CustomImage(path: 'assets/svg/islamic_pattern.svg', imageType: ImageType.svg, fit: BoxFit.cover, height: screenSize.height * 2, width: screenSize.width * 2, color: Colors.white),
          ),
          Opacity(opacity: 0.4, child: CustomImage(path: 'assets/svg/modal.svg', imageType: ImageType.svg, fit: BoxFit.cover, height: screenSize.height * 2, width: screenSize.width * 2)),
          if (showEmblem)
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.15,
                child: CustomImage(path: 'assets/svg/emblem.svg', imageType: ImageType.svg, color: CColors.primary, height: screenSize.height * 0.22, width: screenSize.width * 0.8),
              ),
            ),
          SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Padding(
              padding: margin ?? EdgeInsets.symmetric(vertical: screenSize.height * 0.13, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (backgroundType == BackgroundType.logo || backgroundType == BackgroundType.logoWithSkip)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: logoAlign,
                          children: [
                            CustomImage(path: DefaultImages.logoWithName, imageType: ImageType.svg, width: screenSize.width * 0.4),
                            if (backgroundType == BackgroundType.logoWithSkip)
                              GestureDetector(onTap: onSkipTap, child: Text(LocaleKeys.skip.tr(), style: CTextStyle.w400(fontSize: 22, color: CColors.primary, decoration: TextDecoration.underline))),
                          ],
                        ),
                      ],
                    ),
                  if (title != null)
                    Align(
                      alignment: titleAlignment,
                      child: Padding(padding: titleMargin ?? const EdgeInsets.only(top: 20), child: Text(title!, textDirection: TextDirection.rtl, style: titleStyle ?? CTextStyle.w500(fontSize: 22))),
                    ),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
