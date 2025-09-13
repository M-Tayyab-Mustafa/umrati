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
      await linkWithCredentials(context: context, credential: credential, email: googleUser.email);
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
      await linkWithCredentials(context: context, credential: oauthCredential, email: appleCredential.email ?? '');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        await linkWithCredentials(context: context, credential: credential, email: userData['email']);
      } else {
        errorToast(result.message.toString());
        log(result.message.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> linkWithCredentials({required BuildContext context, required AuthCredential credential, required String email}) async {
    try {
      var querySnapshot = await userCollection.where('email', isEqualTo: email).get().timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      if (querySnapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromMap(querySnapshot.docs.first.data());
        await _auth.signInWithEmailAndPassword(email: user.email, password: user.password);
        await _auth.currentUser?.linkWithCredential(credential);
        infoToast('Login Successfully');
        await LocalStorageManager.saveUser(user, toFirebase: false);
        Navigator.popUntil(context, (route) => route.isFirst);
        ref.read(splashProvider.notifier).redirections(context);
      } else {
        await _signWithCredentials(context: context, credential: credential);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'provider-already-linked') {
        await _signWithCredentials(context: context, credential: credential);
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  //Common For Every Login.
  Future<void> _signWithCredentials({required BuildContext context, required AuthCredential credential}) async {
    try {
      var userCredential = await _auth.signInWithCredential(credential).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      UserModel user;
      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? '',
          photo: userCredential.user!.photoURL ?? '',
          password: Helper.generateRandomId(),
          phone: '',
          country_code: '',
          gender: '',
        );
        await _auth.currentUser
            ?.linkWithCredential(EmailAuthProvider.credential(email: userCredential.user!.email!, password: user.password))
            .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      } else {
        var querySnapshot = await userCollection
            .where('email', isEqualTo: userCredential.user!.email!)
            .get()
            .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
        user = UserModel.fromMap(querySnapshot.docs.first.data());
      }
      await LocalStorageManager.saveUser(user, created_at: FieldValue.serverTimestamp());
      infoToast("Login Successfully");
      Navigator.popUntil(context, (route) => route.isFirst);
      ref.read(splashProvider.notifier).redirections(context);
    } catch (e) {
      rethrow;
    }
  }
}
