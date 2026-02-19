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
  final storageRef = FirebaseStorage.instance.ref();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final editNameController = TextEditingController();

  int daysRemaining = -1;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialization() async {
    user = await LocalStorageManager.getUser(fromFirebase: true);
    if (user != null) {
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

  Future<XFile?> _pickImage(BuildContext context) async {
    return await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: context.edgeInsets(vertical: 20),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: context.edgeInsets(bottom: 10), child: Text(LocaleKeys.choose_image.tr(), style: CTextStyle.w900(fontSize: 18))),
              _PickOption(
                icon: Icons.camera_alt_rounded,
                title: LocaleKeys.camera.tr(),
                subtitle: LocaleKeys.take_a_new_photo.tr(),
                onTap: () async {
                  final photo = await picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, photo);
                },
              ),

              Padding(
                padding: context.edgeInsets(bottom: 24),
                child: _PickOption(
                  icon: Icons.photo_library_rounded,
                  title: LocaleKeys.gallery.tr(),
                  subtitle: LocaleKeys.select_from_gallery.tr(),
                  onTap: () async {
                    final photo = await picker.pickImage(source: ImageSource.gallery);
                    Navigator.pop(context, photo);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onProfileImageTap() async {
    try {
      final XFile? photo = await _pickImage(context);
      if (photo == null) return;
      var croppedFile = await cropper.cropImage(
        sourcePath: photo.path,
        compressFormat: ImageCompressFormat.png,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [AndroidUiSettings(hideBottomControls: true, toolbarTitle: 'Cropper', toolbarColor: CColors.primary, toolbarWidgetColor: Colors.white, lockAspectRatio: true)],
      );
      if (croppedFile == null) return;
      infoToast(LocaleKeys.profile_image_uploading.tr());
      var child = storageRef.child('/${StorageFolderNames.profileImages.name}/${user!.uid}');
      await child.putFile(File(croppedFile.path));
      var url = await child.getDownloadURL();
      user = user!.copyWith(photo: url);
      notifyListeners();
      infoToast(LocaleKeys.profile_image_updated_successfully.tr());
      await LocalStorageManager.saveUser(user!);
    } catch (e) {
      appLog(e.toString());
    }
  }

  Future<void> onLogoutTap() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.are_you_sure_you_want_to_log_out.tr()));
    if (result == true) {
      isLoading = true;
      notifyListeners();
      try {
        await _auth.signOut();
        await LocalStorageManager.clearStorage();
        ref.read(loginProvider.notifier).resetPage();
        // ref.read(loginProvider.notifier).phoneNumberController.clear();
        ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
      } catch (e) {
        appLog(e.toString());
      }
    }
  }

  Future<void> onDeleteAccountTap() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.are_you_sure_you_want_to_delete_account.tr()));
    if (result == true) {
      isLoading = true;
      notifyListeners();
      try {
        await _auth.currentUser?.delete();
        await userCollection.doc(user!.uid).delete();
        await LocalStorageManager.clearStorage();
        ref.read(loginProvider.notifier).resetPage();
        // ref.read(loginProvider.notifier).phoneNumberController.clear();
        ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
      } on FirebaseAuthException catch (e) {
        isLoading = false;
        notifyListeners();
        if (e.code == 'requires-recent-login') {
          appLog(e.toString());
          errorToast(LocaleKeys.requires_recent_login.tr());
        } else {
          appLog(e.toString());
          errorToast(e.message ?? LocaleKeys.something_went_wrong_please_try_again_later.tr());
        }
      } catch (e) {
        isLoading = false;
        notifyListeners();
        appLog(e.toString());
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
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }
}

class _PickOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PickOption({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: CColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: CColors.primary, size: 26)),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))]),
          ],
        ),
      ),
    );
  }
}
