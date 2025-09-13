import '../../export.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(languageProvider);
    return Background(
      title: LocaleKeys.change_the_language.tr(),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.languages.length,
              itemBuilder: (context, index) {
                bool isSelected = provider.languages[index] == provider.selectedLanguage;
                return GestureDetector(
                  onTap: () => ref.read(languageProvider.notifier).updateLanguage(context, provider.languages[index]),
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
          CButton(onTap: () => ref.read(languageProvider.notifier).continueTap(context), title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
