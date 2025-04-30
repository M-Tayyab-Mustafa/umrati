import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/language/select_language_provider.dart';
import '../utils/helper/constants.dart';
import '../utils/services/translations/locale_keys.g.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import '../widgets/background.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';

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
                GestureDetector(onTap: () => provider.changeLanguageTap(context), child: Text(LocaleKeys.change_the_language.tr(), style: CTextStyle.w600(color: CColors.primary))),
              ],
            ),
          ),
          CButton(onTap: () => provider.continueTap(context), title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
