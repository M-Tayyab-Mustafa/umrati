import '../../export.dart';

class EmailOrPhoneLinkingPage extends ConsumerStatefulWidget {
  const EmailOrPhoneLinkingPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailOrPhoneLinkingPageState();
}

class _EmailOrPhoneLinkingPageState extends ConsumerState<EmailOrPhoneLinkingPage> {
  @override
  void initState() {
    super.initState();
    ref.read(emailOrPhoneLinkingProvider.notifier).initialization();
    ref.read(emailOrPhoneLinkingProvider.notifier).ref = ref;
    ref.read(emailOrPhoneLinkingProvider.notifier).context = context;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(emailOrPhoneLinkingProvider);
    return Background(
      backgroundType: BackgroundType.logo,
      title: (provider.user?.email ?? '').isEmpty ? LocaleKeys.link_your_email_to_secure_your_account.tr() : LocaleKeys.phone_mandatory.tr(),
      child: SingleChildScrollView(child: (provider.user?.email ?? '').isEmpty ? const _EmailLinkingPage() : const _PhoneLinkingPage()),
    );
  }
}

class _EmailLinkingPage extends ConsumerWidget {
  const _EmailLinkingPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(emailOrPhoneLinkingProvider);
    return Column(
      children: [
        CTextField(
          margin: EdgeInsets.only(top: screenSize.height * 0.08),
          controller: ref.read(emailOrPhoneLinkingProvider.notifier).emailController,
          keyboardType: TextInputType.emailAddress,
          labelText: LocaleKeys.email.tr(),
        ),
        CButton(
          isLoading: provider.isLinkingAccount,
          margin: EdgeInsets.only(top: screenSize.height * 0.08),
          onTap: ref.read(emailOrPhoneLinkingProvider.notifier).linkAccount,
          title: LocaleKeys.link_account.tr(),
          titleWithIcon: true,
        ),
      ],
    );
  }
}

class _PhoneLinkingPage extends ConsumerWidget {
  const _PhoneLinkingPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(emailOrPhoneLinkingProvider);
    return Column(
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
        CButton(isLoading: provider.isLinkingAccount, onTap: provider.linkAccount, margin: const EdgeInsets.only(top: 35), titleWithIcon: true, title: LocaleKeys.continued.tr()),
      ],
    );
  }
}
