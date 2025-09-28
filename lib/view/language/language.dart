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
      margin: EdgeInsets.only(left: 32, right: 32, top: kToolbarHeight, bottom: kToolbarHeight),
      titleMargin: EdgeInsets.only(top: kToolbarHeight, bottom: kToolbarHeight / 2),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.languages.length,
              itemBuilder: (context, index) {
                bool isSelected = provider.languages[index] == provider.selectedLanguage;
                return GestureDetector(
                  onTap: () => ref.read(languageProvider.notifier).updateLanguage(provider.languages[index]),
                  child: BasicCard(
                    margin: EdgeInsets.only(top: index != 0 ? 30 : 20),
                    borderColor: isSelected ? CColors.primary : CColors.lightGrey,
                    boxShadow: isSelected ? null : [],
                    child: Text(provider.languages[index].tr(), style: CTextStyle.w600()),
                  ),
                );
              },
            ),
          ),
          CButton(onTap: ref.read(languageProvider.notifier).continueTap, title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
