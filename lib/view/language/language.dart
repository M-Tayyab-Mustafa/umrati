import '../../export.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageNotifier = ref.watch(languageProvider.notifier);
    return Background(
      title: LocaleKeys.change_the_language.tr(),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languageNotifier.languages.length,
              itemBuilder: (context, index) {
                bool isSelected = languageNotifier.languages[index] == ref.watch(languageProvider).selectedLanguage;
                return GestureDetector(
                  onTap: () => languageNotifier.updateLanguage(context, languageNotifier.languages[index]),
                  child: BasicCard(
                    margin: EdgeInsets.only(top: index != 0 ? 30 : 20),
                    borderColor: isSelected ? CColors.primary : CColors.lightGrey,
                    boxShadow: isSelected ? null : [],
                    child: Text(languageNotifier.languages[index].tr(), style: CTextStyle.w600()),
                  ),
                );
              },
            ),
          ),
          CButton(onTap: () => languageNotifier.continueTap(context), title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
