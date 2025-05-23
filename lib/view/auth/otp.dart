import '../../export.dart';
import '../../controller/auth/login_provider.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/pin_input.dart';

class OTPPage extends ConsumerStatefulWidget {
  const OTPPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(loginProvider.notifier);
    return Background(
      backgroundType: BackgroundType.logo,
      title: LocaleKeys.otp_verification.tr(),
      titleMargin: EdgeInsets.only(top: 20, bottom: 10),
      titleStyle: CTextStyle.w500(fontSize: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${LocaleKeys.enter_the_otp_you_received_to.tr()}\n', style: CTextStyle.w500(color: CColors.primary, height: 0.5)),
              Directionality(textDirection: TextDirection.ltr, child: Text('${provider.selectedCountry.dialCode} ${provider.phoneNumberController.text}', style: CTextStyle.w500())),
            ],
          ),
          PinInput(controller: provider.otpController, margin: EdgeInsets.symmetric(vertical: 50)),
          CButton(isLoading: provider.isVerifyingOTP, onTap: () => provider.verifyOTP(context), title: LocaleKeys.verify_the_otp.tr(), titleWithIcon: true),

          if (provider.bounceTimer != null)
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Text(
                '${LocaleKeys.resend_the_otp_in.tr()} ${ref.watch(loginProvider).countDown}',
                style: CTextStyle.w500(color: CColors.primary, fontSize: 14, decoration: TextDecoration.underline),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: GestureDetector(
                onTap: provider.resendOTP,
                child: Text(LocaleKeys.resend_the_otp.tr(), style: CTextStyle.w500(color: CColors.primary, fontSize: 14, decoration: TextDecoration.underline)),
              ),
            ),
        ],
      ),
    );
  }
}
