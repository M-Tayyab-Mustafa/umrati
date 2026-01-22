import '../../export.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(loginProvider);
    return Background(
      backgroundType: BackgroundType.logo,
      title: LocaleKeys.log_in_to_your_account.tr(),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhoneNumberTextField(
              margin: context.edgeInsets(top: 40),
              controller: provider.phoneNumberController,
              onChanged: (value) => Helper.fixPhoneFormate(value, provider.phoneNumberController),
              initialCountryCode: provider.selectedCountry,
              updateSelectedCountry: provider.updateSelectedCountry,
              withCountryCodePicker: true,
            ),
            CButton(isLoading: provider.isSendingOTP || provider.isSocialLogin, onTap: () => provider.sendTheOTP(context), margin: context.edgeInsets(top: 35), titleWithIcon: true, title: LocaleKeys.verify_now.tr()),
            Padding(padding: context.edgeInsets(vertical: 40), child: Divider()),
            Padding(
              padding: context.edgeInsets(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: context.edgeInsets(left: 15, bottom: 15), child: Text(LocaleKeys.or_continue_with.tr(), style: CTextStyle.w500())),
                  Row(
                    children: [
                      Expanded(child: CustomImage(onTap: () => provider.googleLogin(context, ref), path: 'assets/svg/google_with_border.svg', imageType: ImageType.svg, width: context.w(100))),
                      // Expanded(child: CustomImage(onTap: provider.facebookLogin, path: 'assets/svg/facebook_with_border.svg', imageType: ImageType.svg, width: SizeConfig.w(100))),
                      Expanded(child: CustomImage(onTap: () => provider.appleLogin(context, ref), path: 'assets/svg/apple_with_border.svg', imageType: ImageType.svg, width: context.w(100))),
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
