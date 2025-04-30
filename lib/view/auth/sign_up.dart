import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/auth/sign_up_provider.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/text_field.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(signUpProvider);
    return Background(
      title: LocaleKeys.register_your_account.tr(),
      backgroundType: BackgroundType.logoWithSkip,
      titleMargin: EdgeInsets.only(top: 15, bottom: 40),
      onSkipTap: () => provider.skip(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CTextField(labelText: LocaleKeys.name.tr(), keyboardType: TextInputType.name),
          CTextField(labelText: LocaleKeys.email.tr(), margin: EdgeInsets.only(top: 40, bottom: 30), keyboardType: TextInputType.emailAddress),
          CButton(isLoading: provider.registeringWithEmail, onTap: () => provider.continueTap(context), title: LocaleKeys.continued.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
