import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../widgets/background.dart';
import '../../widgets/custom_image.dart';
import '../controller/auth/gender_provider.dart';
import '../widgets/button.dart';

class SelectGenderPage extends ConsumerWidget {
  const SelectGenderPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(genderProvider);
    return Background(
      title: LocaleKeys.select_your_gender.tr(),
      backgroundType: BackgroundType.logoWithSkip,
      onSkipTap: () => provider.skip(context),
      titleMargin: EdgeInsets.only(top: 60, bottom: 40),
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
                  path: provider.selectedGender == Gender.male ? 'assets/svg/gender/selected_male.svg' : 'assets/svg/gender/un_selected_male.svg',
                  imageType: ImageType.svg,
                  fit: BoxFit.fill,
                  height: 180,
                ),
              ),
              Expanded(
                child: CustomImage(
                  onTap: () => provider.updateGender(Gender.female),
                  path: provider.selectedGender == Gender.female ? 'assets/svg/gender/selected_female.svg' : 'assets/svg/gender/un_selected_female.svg',
                  imageType: ImageType.svg,
                  fit: BoxFit.fill,
                  height: 180,
                ),
              ),
            ],
          ),
          CButton(isLoading: provider.isUpdatingGender, onTap: () => provider.continueTap(context), margin: EdgeInsets.only(top: 40), title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
