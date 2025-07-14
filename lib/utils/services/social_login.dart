import '../../export.dart';
import '../../view/auth/gender.dart';
import '../../view/nav/page.dart';

class SocialLoginService {
  SocialLoginService._();

  static final _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _signWithCredentials(context: context, credential: credential);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: AppleIDAuthorizationScopes.values,
        webAuthenticationOptions: WebAuthenticationOptions(
          //Todo:: Required Apple Service ID
          clientId: 'de.lunaone.flutter.signinwithappleexample.service',
          //Todo:: Required redirect URI
          redirectUri: Uri.parse('https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple'),
        ),
      ).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      final oauthCredential = OAuthProvider("apple.com").credential(idToken: appleCredential.identityToken, accessToken: appleCredential.authorizationCode);
      await _signWithCredentials(context: context, credential: oauthCredential);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        await _signWithCredentials(context: context, credential: credential);
      } else {
        errorToast(result.message.toString());
        log(result.message.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  //Common For Every Login.
  static Future<void> _signWithCredentials({required BuildContext context, required AuthCredential credential}) async {
    try {
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
      rethrow;
    }
  }
}
