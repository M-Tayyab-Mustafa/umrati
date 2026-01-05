import '../../export.dart';

class SelectGenderPage extends ConsumerStatefulWidget {
  const SelectGenderPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectGenderPageState();
}

class _SelectGenderPageState extends ConsumerState<SelectGenderPage> {
  @override
  void initState() {
    super.initState();
    ref.read(genderProvider.notifier).ref = ref;
    ref.read(genderProvider.notifier).context = context;
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(genderProvider);
    return Background(
      title: LocaleKeys.select_your_gender.tr(),
      backgroundType: BackgroundType.logoWithSkip,
      isSkipLoading: provider.isUpdatingGender,
      onSkipTap: provider.skip,
      titleMargin: context.edgeInsets(top: 50, bottom: 40),
      titleAlignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: CustomImage(
                  onTap: () => provider.updateGender(Gender.male),
                  path:
                      provider.selectedGender == Gender.male
                          ? isLTR(context)
                              ? 'assets/svg/gender/selected_male.svg'
                              : 'assets/svg/gender/selected_male_ur.svg'
                          : isLTR(context)
                          ? 'assets/svg/gender/un_selected_male.svg'
                          : 'assets/svg/gender/un_selected_male_ur.svg',
                  imageType: ImageType.svg,
                  fit: BoxFit.fill,
                  height: context.h(120),
                ),
              ),
              Expanded(
                child: CustomImage(
                  onTap: () => provider.updateGender(Gender.female),
                  path:
                      provider.selectedGender == Gender.female
                          ? isLTR(context)
                              ? 'assets/svg/gender/selected_female.svg'
                              : 'assets/svg/gender/selected_female_ur.svg'
                          : isLTR(context)
                          ? 'assets/svg/gender/un_selected_female.svg'
                          : 'assets/svg/gender/un_selected_female_ur.svg',
                  imageType: ImageType.svg,
                  fit: BoxFit.fill,
                  height: context.h(120),
                ),
              ),
            ],
          ),
          CButton(isLoading: provider.isUpdatingGender, onTap: provider.continueTap, margin: context.edgeInsets(top: 40), title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
