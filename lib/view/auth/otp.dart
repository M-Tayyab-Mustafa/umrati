import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth/otp_provider.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/pin_input.dart';

class OTPPage extends ConsumerWidget {
  const OTPPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(otpProvider.notifier);
    return Background(
      backgroundType: BackgroundType.logo,
      title: LocaleKeys.otp_verification.tr(),
      titleMargin: EdgeInsets.only(top: 20, bottom: 10),
      titleStyle: CTextStyle.w500(fontSize: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${LocaleKeys.enter_the_otp_you_received_to.tr()}\n', style: CTextStyle.w500(color: CColors.primary, height: 1.5)),
                TextSpan(text: '+92 ${provider.phoneNumber}', style: CTextStyle.w500()),
              ],
            ),
          ),
          PinInput(controller: provider.otpController, margin: EdgeInsets.symmetric(vertical: 50)),
          CButton(isLoading: provider.isVerifyingOTP, onTap: () => provider.verifyOTP(context), title: LocaleKeys.verify_the_otp.tr(), titleWithIcon: true),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: Text(LocaleKeys.resend_the_otp.tr(), style: CTextStyle.w500(color: CColors.primary, fontSize: 14, decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}
