import 'package:umrati/view/language/select_language.dart';

import '../../../export.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CButton(
          title: 'Logout',
          onTap: () async {
            await LocalStorageManager.clearStorage();
            try {
              await FirebaseAuth.instance.signOut();
            } catch (e) {
              log(e.toString());
            }
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectLanguagePage()));
          },
        ),
      ],
    );
  }
}
