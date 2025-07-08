import '../../export.dart';
import '../../view/auth/gender.dart';
import '../../view/nav/page.dart';

class SocialLoginService {
  static final _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var userCredential = await _auth.signInWithCredential(credential);
      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        phone: userCredential.user!.phoneNumber ?? '',
        photo: userCredential.user!.photoURL ?? '',
        gender: Gender.unknown.name.toLowerCase(),
      );
      await LocalStorageManager.saveUser(user);
      LocalStorageManager.showLoginPage(false);
      if (userCredential.user?.emailVerified ?? false) {
        infoToast("Google Login Successfully");
        Navigator.popUntil(context, (route) => route.isFirst);
        if (userCredential.additionalUserInfo!.isNewUser) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectGenderPage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
        }
      } else {
        infoToast("We have sent you an email verification, please verify your email.");
        await _auth.currentUser?.sendEmailVerification();
      }
    } catch (e) {
      errorToast('Something went wrong!. Try again later.');
      log(e.toString());
    }
  }
}
