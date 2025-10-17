import '../../../export.dart';
import '../../../view/subscription/page.dart';

final profileProvider = ChangeNotifierProvider.autoDispose<ProfileNotifier>((ref) => ProfileNotifier());

class ProfileNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  UserModel? user;
  String localImagePath = 'assets/png/profile/male_avatar.png';
  bool isLoading = true;
  final ImagePicker picker = ImagePicker();
  final ImageCropper cropper = ImageCropper();
  final storageRef = FirebaseStorage.instance.refFromURL('gs://umrati-ec453.firebasestorage.app');

  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final editNameController = TextEditingController();

  int daysRemaining = -1;

  Future<void> initialization() async {
    user = await LocalStorageManager.getUser(fromFirebase: true);
    if (user != null) {
      numberController.text = user!.phone;
      emailController.text = user!.email;
      nameController.text = user!.name.isEmpty ? user!.uid.substring(0, (user!.uid.length / 2).toInt()) : user!.name;
    }
    if (user!.photo.isEmpty) {
      if (user!.gender == Gender.female.name) {
        localImagePath = 'assets/png/profile/female_avatar.png';
      } else {
        localImagePath = 'assets/png/profile/male_avatar.png';
      }
    }
    if (user!.subscription_id != null && user!.subscription_id!.isNotEmpty) {
      var subscriptionDoc = await subscriptionCollection.doc(user!.subscription_id).get();
      final subscription = SubscriptionModel.fromMap(subscriptionDoc.data()!);
      final expireData = subscription.expire_at!.toDate();
      daysRemaining = expireData.difference(DateTime.now()).inDays;
    }
    isLoading = false;
    if (context.mounted) notifyListeners();
  }

  Future<void> onProfileImageTap() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      var croppedFile = await cropper.cropImage(
        sourcePath: photo.path,
        compressFormat: ImageCompressFormat.png,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [AndroidUiSettings(hideBottomControls: true, toolbarTitle: 'Cropper', toolbarColor: CColors.primary, toolbarWidgetColor: Colors.white, lockAspectRatio: true)],
      );
      if (croppedFile != null) {
        infoToast(LocaleKeys.profile_image_uploading.tr());
        var child = storageRef.child('/${StorageFolderNames.profileImages.name}/${user!.uid}');
        await child.putFile(File(croppedFile.path));
        var url = await child.getDownloadURL();
        user = user!.copyWith(photo: url);
        notifyListeners();
        infoToast(LocaleKeys.profile_image_updated_successfully.tr());
        await LocalStorageManager.saveUser(user!);
      }
    }
  }

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
      try {
        ref.read(loginProvider.notifier).resetPage();
        ref.read(loginProvider.notifier).phoneNumberController.clear();
      } catch (e) {
        if (kDebugMode) log(e.toString());
      }
      ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
    }
  }

  Future<void> onDeleteAccountTap() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.are_you_sure_you_want_to_delete_account.tr()));
    if (result == true) {
      isLoading = true;
      notifyListeners();
      await userCollection.doc(user!.uid).delete();
      await LocalStorageManager.clearStorage();
      try {
        await FirebaseAuth.instance.currentUser?.delete();
        ref.read(loginProvider.notifier).resetPage();
        ref.read(loginProvider.notifier).phoneNumberController.clear();
        ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
      } on FirebaseAuthException catch (e) {
        isLoading = false;
        notifyListeners();
        if (kDebugMode) log(e.toString());
        errorToast(e.message ?? LocaleKeys.something_went_wrong_please_try_again_later.tr());
      } catch (e) {
        isLoading = false;
        notifyListeners();
        if (kDebugMode) log(e.toString());
      }
    }
  }

  Future<void> updateGender(Gender gender) async {
    user = user!.copyWith(gender: gender.name.toLowerCase());
    if (user!.photo.isEmpty) {
      if (user!.gender == Gender.female.name) {
        localImagePath = 'assets/png/profile/female_avatar.png';
      } else {
        localImagePath = 'assets/png/profile/male_avatar.png';
      }
    }
    notifyListeners();
    await LocalStorageManager.saveUser(user!);
  }

  Future<void> updateName() async {
    editNameController.text = nameController.text.trim();
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return EditNameDialog(
          controller: editNameController,
          onUpdate: () async {
            user = user!.copyWith(name: editNameController.text.trim());
            notifyListeners();
            await LocalStorageManager.saveUser(user!);
            nameController.text = editNameController.text.trim();
            infoToast(LocaleKeys.name_updated_successfully.tr());
          },
        );
      },
    );
  }

  Future<void> renew() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionPlansPage(isRenewingPlan: true)));
    initialization();
  }

  @override
  void dispose() {
    numberController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
