import '../../export.dart';

class SocialLoginService {
  SocialLoginService._();
  static final SocialLoginService _instance = SocialLoginService._();
  static SocialLoginService get instance => _instance;

  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  Future<void> signInWithGoogle(BuildContext context) async {
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

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: AppleIDAuthorizationScopes.values,
        webAuthenticationOptions: WebAuthenticationOptions(clientId: 'com.mightysofts.umrati.service', redirectUri: Uri.parse('https://umrati-ec453.firebaseapp.com/__/auth/handler')),
      ).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      final oauthCredential = OAuthProvider("apple.com").credential(idToken: appleCredential.identityToken, accessToken: appleCredential.authorizationCode);
      await _signWithCredentials(context: context, credential: oauthCredential);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
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
  Future<void> _signWithCredentials({required BuildContext context, required AuthCredential credential}) async {
    try {
      var userCredential = await _auth.signInWithCredential(credential);
      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        photo: userCredential.user!.photoURL ?? '',
        phone: '',
        country_code: '',
        gender: '',
      );
      await LocalStorageManager.saveUser(user, created_at: FieldValue.serverTimestamp());
      if (userCredential.user?.emailVerified ?? false) {
        infoToast("Google Login Successfully");
        Navigator.popUntil(context, (route) => route.isFirst);
        ref.read(splashProvider).redirections(context);
      } else {
        infoToast("We have sent you an email verification, please verify your email.");
        await _auth.currentUser?.sendEmailVerification();
      }
    } catch (e) {
      rethrow;
    }
  }
}
