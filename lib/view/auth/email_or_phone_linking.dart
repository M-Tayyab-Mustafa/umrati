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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(emailOrPhoneLinkingProvider.notifier).initialization();
    });
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
        RepaintBoundary(
          child: CTextField(margin: context.edgeInsets(top: screenSize.height * 0.08), controller: ref.read(emailOrPhoneLinkingProvider.notifier).emailController, keyboardType: TextInputType.emailAddress, labelText: LocaleKeys.email.tr()),
        ),
        CButton(isLoading: provider.isLinkingAccount, margin: context.edgeInsets(top: screenSize.height * 0.08), onTap: () => provider.linkAccount(context, ref), title: LocaleKeys.link_account.tr(), titleWithIcon: true),
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
        PhoneNumberTextField(
          margin: context.edgeInsets(top: 40),
          withCountryCodePicker: true,
          controller: provider.phoneNumberController,
          onChanged: (value) => Helper.fixPhoneFormate(value, provider.phoneNumberController),
          updateSelectedCountry: provider.updateSelectedCountry,
          initialCountryCode: provider.selectedCountry,
        ),
        CButton(isLoading: provider.isLinkingAccount, onTap: () => provider.linkAccount(context, ref), margin: context.edgeInsets(top: 35), titleWithIcon: true, title: LocaleKeys.continued.tr()),
      ],
    );
  }
}
