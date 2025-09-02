import '../../export.dart';

class PhoneNoPage extends ConsumerStatefulWidget {
  const PhoneNoPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhoneNoPageState();
}

class _PhoneNoPageState extends ConsumerState<PhoneNoPage> {
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(phoneProvider);
    ref.read(phoneProvider).context = context;
    ref.read(phoneProvider).ref = ref;
    return Background(
      backgroundType: BackgroundType.logo,
      title: LocaleKeys.phone_mandatory.tr(),
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
            CButton(isLoading: provider.isLoading, onTap: provider.continueTap, margin: const EdgeInsets.only(top: 35), titleWithIcon: true, title: LocaleKeys.continued.tr()),
          ],
        ),
      ),
    );
  }
}
