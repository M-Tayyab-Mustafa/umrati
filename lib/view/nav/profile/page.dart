import '../../../export.dart';
import '../../language/select_language.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CButton(
              title: 'LogOut',
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
      ),
    );
  }
}
