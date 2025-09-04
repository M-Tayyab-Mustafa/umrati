import 'package:umrati/view/language/select_language.dart';

import '../../../export.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CButton(
            title: 'Logout',
            onTap: () async {
              try {
                await LocalStorageManager.clearStorage();
                await FirebaseAuth.instance.signOut();
              } catch (e) {
                if (kDebugMode) log(e.toString());
                errorToast(e.toString());
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectLanguagePage()));
            },
          ),
        ],
      ),
    );
  }
}
