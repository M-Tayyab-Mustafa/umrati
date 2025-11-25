import '../../export.dart';

class OTPPage extends ConsumerWidget {
  const OTPPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(loginProvider);
    return Background(
      backgroundType: BackgroundType.logo,

      title: LocaleKeys.otp_verification.tr(),
      titleMargin: ScaledEdgeInsets.symmetric(vertical: 10),
      titleStyle: CTextStyle.w500(fontSize: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${LocaleKeys.enter_the_otp_you_received_to.tr()}\n', style: CTextStyle.w500(color: CColors.primary, height: 0.5, fontSize: 14)),
              Directionality(textDirection: TextDirection.ltr, child: Text('${provider.selectedCountry.dialCode} ${provider.phoneNumberController.text}', style: CTextStyle.w500(fontSize: 14))),
            ],
          ),
          Center(child: Directionality(textDirection: TextDirection.ltr, child: PinInput(controller: provider.otpController, margin: ScaledEdgeInsets.symmetric(vertical: 30)))),
          CButton(isLoading: provider.isVerifyingOTP, onTap: provider.verifyOTP, title: LocaleKeys.verify.tr(), titleWithIcon: true),

          if (provider.bounceTimer != null)
            Padding(
              padding: ScaledEdgeInsets.only(top: 40, left: 10),
              child: Text('${LocaleKeys.resend_the_otp_in.tr()} ${ref.watch(loginProvider).countDown}', style: CTextStyle.w500(color: CColors.primary, fontSize: 14, decoration: TextDecoration.underline)),
            )
          else
            Padding(
              padding: ScaledEdgeInsets.only(top: 40, left: 10),
              child: GestureDetector(onTap: provider.resendOTP, child: Text(LocaleKeys.resend_the_otp.tr(), style: CTextStyle.w500(color: CColors.primary, fontSize: 14, decoration: TextDecoration.underline))),
            ),
        ],
      ),
    );
  }
}
