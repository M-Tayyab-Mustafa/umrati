import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth/login_provider.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/text_field.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(loginProvider);
    return Background(
      backgroundType: BackgroundType.logoWithSkip,
      onSkipTap: () => provider.skip(context),
      title: LocaleKeys.log_in_to_your_account.tr(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CTextField(
              labelText: LocaleKeys.number.tr(),
              margin: EdgeInsets.only(top: 40),
              controller: provider.phoneNumberController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              prefixMargin: EdgeInsets.only(left: 16, top: 3),
              onPrefixTap: () => provider.updateSelectedCountry(context),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(path: provider.selectedCountry.icon, imageType: ImageType.png, height: 25, width: 25),
                  Padding(padding: EdgeInsets.only(left: 12), child: CustomImage(path: 'assets/svg/arrow_down.svg', imageType: ImageType.svg, height: 6, width: 15)),
                  Padding(padding: EdgeInsets.only(left: 4), child: Text(provider.selectedCountry.code, style: CTextStyle.w500(fontSize: 14, color: CColors.greyShade1))),
                ],
              ),
            ),
            CButton(isLoading: provider.isSendingOTP, onTap: () => provider.sendTheOTP(context), margin: const EdgeInsets.only(top: 35), titleWithIcon: true, title: LocaleKeys.send_the_otp.tr()),
            Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Divider()),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: EdgeInsets.only(left: 15, bottom: 10), child: Text(LocaleKeys.or_continue_with.tr(), style: CTextStyle.w500())),
                  const Row(
                    children: [
                      Expanded(child: CustomImage(path: 'assets/svg/google_with_border.svg', imageType: ImageType.svg)),
                      Expanded(child: CustomImage(path: 'assets/svg/facebook_with_border.svg', imageType: ImageType.svg)),
                      Expanded(child: CustomImage(path: 'assets/svg/apple_with_border.svg', imageType: ImageType.svg)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
