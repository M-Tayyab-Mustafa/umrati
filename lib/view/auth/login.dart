import '../../export.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(loginProvider);
    ref.read(loginProvider).context = context;
    ref.read(loginProvider).ref = ref;
    SocialLoginService.instance.ref = ref;
    return Background(
      backgroundType: BackgroundType.logoWithSkip,
      isSkipLoading: provider.isSendingOTP || provider.isSkipping || provider.isSocialLogin,
      onSkipTap: provider.skip,
      title: LocaleKeys.log_in_to_your_account.tr(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: CTextField(
                labelText: LocaleKeys.number.tr(),
                margin: const EdgeInsets.only(top: 40),
                controller: provider.phoneNumberController,
                onChanged: provider.onPhoneNumberTextFieldChanged,
                keyboardType: TextInputType.phone,
                inputFormatters: [UsPhoneNumberFormatter()],
                maxLength: provider.numberDigits + 1,
                prefixMargin: const EdgeInsets.only(left: 16, top: 3),
                textDirection: TextDirection.ltr,
                prefixIcon: CountryCodePicker(
                  onChanged: provider.updateSelectedCountry,
                  initialSelection: 'PK',
                  favorite: ['+92', 'PK'],
                  builder: (countryCode) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImage(path: 'assets/png/${countryCode!.flagUri!}', imageType: ImageType.png, height: 25, width: 25),
                        Padding(padding: const EdgeInsets.only(left: 12), child: CustomImage(path: 'assets/svg/arrow_down.svg', imageType: ImageType.svg, height: 6, width: 15)),
                        Padding(padding: const EdgeInsets.only(left: 4), child: Text(countryCode.dialCode!, style: CTextStyle.w500(fontSize: 14, color: CColors.greyShade1))),
                      ],
                    );
                  },
                ),
              ),
            ),
            CButton(
              isLoading: provider.isSendingOTP || provider.isSkipping || provider.isSocialLogin,
              onTap: provider.sendTheOTP,
              margin: const EdgeInsets.only(top: 35),
              titleWithIcon: true,
              title: LocaleKeys.send_the_otp.tr(),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Divider()),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: EdgeInsets.only(left: 15, bottom: 10), child: Text(LocaleKeys.or_continue_with.tr(), style: CTextStyle.w500())),
                  Row(
                    children: [
                      Expanded(child: CustomImage(onTap: provider.googleLogin, path: 'assets/svg/google_with_border.svg', imageType: ImageType.svg)),
                      // Expanded(child: CustomImage(onTap: provider.facebookLogin, path: 'assets/svg/facebook_with_border.svg', imageType: ImageType.svg)),
                      Expanded(child: CustomImage(onTap: provider.appleLogin, path: 'assets/svg/apple_with_border.svg', imageType: ImageType.svg)),
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
