import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/widgets/card.dart';

import '../../../controller/nav/ziarat/provider.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/translations/locale_keys.g.dart';
import '../../../utils/theme/colors.dart';
import '../../../utils/theme/text_style.dart';
import '../../../widgets/button.dart';
import '../../../widgets/custom_image.dart';

class ZiaratDestinations extends ConsumerWidget {
  const ZiaratDestinations({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaratProvider);
    var isAutoSelected = provider.selectedCreationOption == ZiaratDestinationsCreationOptions.auto;
    var isManualSelected = provider.selectedCreationOption == ZiaratDestinationsCreationOptions.manual;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              CustomImage(path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, height: 40, width: 30, margin: EdgeInsets.only(right: 20)),
              Expanded(child: Center(child: Text(LocaleKeys.please_select_one_option_to_continue_your_ziarat.tr(), textAlign: TextAlign.center, style: CTextStyle.w500(fontSize: 24)))),
            ],
          ),
        ),
        BasicCard(
          onTap: () => ref.read(ziaratProvider.notifier).updateSelectedCreationOption(ZiaratDestinationsCreationOptions.auto),
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          borderColor: isAutoSelected ? CColors.primary : CColors.greyShade2,
          boxShadow: isAutoSelected ? null : [],
          borderWidth: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(LocaleKeys.auto_generate.tr(), style: CTextStyle.w400(fontSize: 26, color: isAutoSelected ? CColors.primary : CColors.greyShade2)),
              ),
              Text(LocaleKeys.auto_generate_description.tr(), style: CTextStyle.w400(fontSize: 14, color: isAutoSelected ? CColors.primary : CColors.greyShade2)),
            ],
          ),
        ),
        BasicCard(
          onTap: () => ref.read(ziaratProvider.notifier).updateSelectedCreationOption(ZiaratDestinationsCreationOptions.manual),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          borderColor: isManualSelected ? CColors.primary : CColors.greyShade2,
          boxShadow: isManualSelected ? null : [],
          borderWidth: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(LocaleKeys.manual_selection.tr(), style: CTextStyle.w400(fontSize: 26, color: isManualSelected ? CColors.primary : CColors.greyShade2)),
              ),
              Text(LocaleKeys.manual_selection_description.tr(), style: CTextStyle.w400(fontSize: 14, color: isManualSelected ? CColors.primary : CColors.greyShade2)),
            ],
          ),
        ),
        if (ref.watch(ziaratProvider).selectedCreationOption != null) CButton(title: LocaleKeys.proceed_forward.tr(), width: 200),
      ],
    );
  }
}
