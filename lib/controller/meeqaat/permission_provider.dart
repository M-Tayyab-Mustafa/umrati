import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umrati/utils/helper/constants.dart';
import 'package:umrati/utils/services/translations/locale_keys.g.dart';

import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../view/meeqaat/location_fetched.dart';
import '../../view/tawaf/start.dart';
import '../../widgets/button.dart';

final meeqaatPermissionProvider = ChangeNotifierProvider<MeeqaatPermissionNotifier>((ref) => MeeqaatPermissionNotifier());

class MeeqaatPermissionNotifier extends ChangeNotifier {
  bool isConfirmingMeeqaat = false;

  void skip(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StartTawafPage()));
  }

  void continueTab(BuildContext context) async {
    if (await requestLocationPermission()) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatLocationFetchedPage()));
    } else {
      showDialog(
        context: context,
        builder:
            (dialogContext) => AlertDialog(
              title: Text(LocaleKeys.location_permission_needed.tr(), style: CTextStyle.w800(color: CColors.deepTeal)),
              content: Text(LocaleKeys.permission_description.tr(), style: CTextStyle.w400(color: CColors.deepTeal, fontSize: 14)),
              actions: [
                CButton(
                  onTap: () async {
                    Navigator.pop(dialogContext);
                    await openAppSettings();
                  },
                  title: LocaleKeys.open_setting.tr(),
                ),
              ],
            ),
      );
    }
  }
}
