import '../../export.dart';

class LanguagePage extends ConsumerStatefulWidget {
  const LanguagePage({super.key, this.isUpdatingLanguage = false});
  final bool isUpdatingLanguage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<LanguagePage> {
  @override
  void initState() {
    super.initState();
    ref.read(languageProvider.notifier).isUpdatingLanguage = widget.isUpdatingLanguage;
    ref.read(languageProvider.notifier).context = context;
    ref.read(languageProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(languageProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(languageProvider);
    return Background(
      title: LocaleKeys.change_the_language.tr(),
      titleType: TitleType.backArrow,
      backgroundType: BackgroundType.logo,
      logoAlign: provider.isUpdatingLanguage ? Alignment.center : Alignment.centerLeft,
      margin: SizeConfig.only(top: kToolbarHeight),
      titleMargin: SizeConfig.symmetric(horizontal: 16, vertical: kToolbarHeight / 2),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.languages.length,
              padding: SizeConfig.only(left: 16, right: 16),
              itemBuilder: (context, index) {
                bool isSelected = provider.languages[index] == provider.selectedLanguage;
                return GestureDetector(
                  onTap: () => ref.read(languageProvider.notifier).updateLanguage(provider.languages[index]),
                  child: BasicCard(
                    margin: SizeConfig.only(top: index != 0 ? 20 : 0),
                    borderColor: isSelected ? CColors.primary : CColors.lightGrey,
                    boxShadow: isSelected ? null : [],
                    child: Text(provider.languages[index].tr(), style: CTextStyle.w600(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          CButton(margin: SizeConfig.only(bottom: kToolbarHeight), onTap: ref.read(languageProvider.notifier).continueTap, title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
