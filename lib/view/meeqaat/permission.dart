import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/meeqaat/permission_provider.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';

class MeeqaatPermissionPage extends ConsumerWidget {
  const MeeqaatPermissionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(meeqaatPermissionProvider);
    return Background(
      backgroundType: BackgroundType.logoWithSkip,
      title: LocaleKeys.your_meeqaat_location.tr(),
      titleAlignment: Alignment.center,
      onSkipTap: () => provider.skip(context),
      titleMargin: EdgeInsets.only(top: 60, bottom: 40),
      child: Align(alignment: Alignment.topCenter, child: CButton(title: LocaleKeys.turn_on_your_location_to_find_your_meeqaat.tr(), fontSize: 14, onTap: () => provider.continueTab(context))),
    );
  }
}
