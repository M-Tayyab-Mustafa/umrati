import '../../export.dart';

class SelectLanguagePage extends ConsumerStatefulWidget {
  const SelectLanguagePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends ConsumerState<SelectLanguagePage> {
  @override
  void initState() {
    super.initState();
    ref.read(selectLanguageProvider.notifier).ref = ref;
    ref.read(selectLanguageProvider.notifier).context = context;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(selectLanguageProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      backgroundType: BackgroundType.logo,
      title: LocaleKeys.select_your_language.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BasicCard(
            onTap: ref.read(selectLanguageProvider.notifier).changeLanguageTap,
            margin: SizeConfig.only(top: 70, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ref.watch(selectLanguageProvider).selectedLanguage.tr(), style: CTextStyle.w600(fontSize: 16)),
                Text(LocaleKeys.change_the_language.tr(), style: CTextStyle.w600(color: CColors.primary, fontSize: 16)),
              ],
            ),
          ),
          CButton(onTap: ref.read(selectLanguageProvider.notifier).continueTap, title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
