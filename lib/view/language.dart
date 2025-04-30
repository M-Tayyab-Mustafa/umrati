import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/language/language_provider.dart';
import '../utils/services/translations/locale_keys.g.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import '../widgets/background.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';

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
                bool isSelected = languageNotifier.languages[index] == ref.watch(languageProvider);
                return GestureDetector(
                  onTap: () => languageNotifier.updateLanguage(languageNotifier.languages[index]),
                  child: BasicCard(
                    margin: EdgeInsets.only(top: index != 0 ? 30 : 20),
                    borderColor: isSelected ? CColors.primary : CColors.lightGrey,
                    boxShadow: isSelected ? null : [],
                    child: Text(languageNotifier.languages[index], style: CTextStyle.w600()),
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
