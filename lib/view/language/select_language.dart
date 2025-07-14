import '../../export.dart';

class SelectLanguagePage extends ConsumerWidget {
  const SelectLanguagePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(selectLanguageProvider.notifier);
    return Background(
      backgroundType: BackgroundType.logo,
      title: LocaleKeys.select_your_language.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BasicCard(
            margin: EdgeInsets.only(top: 70, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(LocaleKeys.english.tr(), style: CTextStyle.w600()),
                GestureDetector(onTap: () => provider.changeLanguageTap(context, ref), child: Text(LocaleKeys.change_the_language.tr(), style: CTextStyle.w600(color: CColors.primary))),
              ],
            ),
          ),
          CButton(onTap: () => provider.continueTap(context), title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
