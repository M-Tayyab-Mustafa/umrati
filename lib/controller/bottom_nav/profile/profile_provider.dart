import '../../../export.dart';

final profileProvider = ChangeNotifierProvider.autoDispose<ProfileNotifier>((ref) => ProfileNotifier());

class ProfileNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  UserModel? user;
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  String? localImagePath;
  bool isLoading = true;

  Future<void> initialization() async {
    user = await LocalStorageManager.getUser(fromFirebase: true);
    if (user != null) {
      numberController.text = user!.phone;
      emailController.text = user!.email;
      nameController.text = user!.name.isEmpty ? user!.uid.substring(0, (user!.uid.length / 2).toInt()) : user!.name;
    }
    if (user!.photo.isEmpty) {
      if (user!.gender == Gender.male.name) {
        user = user!.copyWith(photo: 'https://www.pngall.com/wp-content/uploads');
      } else if (user!.gender == Gender.female.name) {
        user = user!.copyWith(photo: 'https://www.pngall.com/wp-content/uploads');
      } else {
        user = user!.copyWith(photo: 'https://www.pngall.com/wp-content/uploads');
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> onProfileImageTap() async {}

  Future<void> onLogoutTap() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.are_you_sure_you_want_to_log_out.tr()));
    if (result == true) {
      isLoading = true;
      notifyListeners();
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        if (kDebugMode) log(e.toString());
      }
      await LocalStorageManager.clearStorage();
      ref.read(splashProvider.notifier).redirections(context, false);
    }
  }

  Future<void> onDeleteAccountTap() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.are_you_sure_you_want_to_delete_account.tr()));
    if (result == true) {
      isLoading = true;
      notifyListeners();
      try {
        await FirebaseAuth.instance.currentUser?.delete();
      } catch (e) {
        if (kDebugMode) log(e.toString());
      }
      await userCollection.doc(user!.uid).delete();
      await LocalStorageManager.clearStorage();
      ref.read(splashProvider.notifier).redirections(context, false);
    }
  }

  @override
  void dispose() {
    numberController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
