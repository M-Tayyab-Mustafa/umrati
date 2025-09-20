import '../../../export.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  initState() {
    super.initState();
    ref.read(profileProvider.notifier).context = context;
    ref.read(profileProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.empty,
      logoAlign: Alignment.center,
      title: LocaleKeys.profile.tr(),
      titleAlignment: Alignment.center,
      titleStyle: CTextStyle.w500(fontSize: 26, letterSpacing: 2),
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06),
      child:
          provider.isLoading
              ? Loading()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: SizedBox(
                          height: 155,
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(160),
                            child: Stack(
                              children: [
                                CustomImage(
                                  enableBorder: true,
                                  border: Border.all(color: CColors.primary, width: 2),
                                  borderRadius: BorderRadius.circular(160),
                                  height: 140,
                                  width: 140,
                                  path: provider.user!.photo.isNotEmpty ? provider.user!.photo : provider.localImagePath,
                                  imageType: provider.user!.photo.isNotEmpty ? ImageType.network : ImageType.png,
                                  fit: BoxFit.cover,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onTap: ref.read(profileProvider.notifier).onProfileImageTap,
                                    child: Container(
                                      height: 40,
                                      width: 55,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white),
                                      child: CustomImage(path: 'assets/svg/camera.svg', imageType: ImageType.svg, width: 25, height: 25, fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (provider.user!.is_premium)
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: CColors.paleYellow, borderRadius: BorderRadius.circular(32)),
                          child: Text(LocaleKeys.premium.tr(), style: CTextStyle.w400(fontSize: 18, letterSpacing: 0.0)),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${provider.user!.total_umra_done}  ', style: CTextStyle.w900(fontSize: 30, color: CColors.primary)),
                          Expanded(child: Text(LocaleKeys.number_of_umra_done.tr(), style: CTextStyle.w400(fontSize: 20, color: CColors.deepTeal))),
                        ],
                      ),
                    ),
                    CTextField(margin: EdgeInsets.only(top: 8), controller: provider.numberController, labelText: LocaleKeys.number.tr(), readOnly: true),
                    CTextField(margin: EdgeInsets.only(top: 32), controller: provider.emailController, labelText: LocaleKeys.email.tr(), readOnly: true),
                    CTextField(
                      margin: EdgeInsets.only(top: 32),
                      controller: provider.nameController,
                      labelText: LocaleKeys.name.tr(),
                      readOnly: true,
                      suffixIcon: CustomImage(path: 'assets/svg/edit.svg', imageType: ImageType.svg, height: 25, width: 25),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 20), child: Text(LocaleKeys.select_your_gender.tr(), style: CTextStyle.w500(fontSize: 18))),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomImage(
                              onTap: () => provider.updateGender(Gender.male),
                              path: provider.user!.gender == Gender.male.name ? 'assets/svg/gender/selected_male.svg' : 'assets/svg/gender/un_selected_male.svg',
                              imageType: ImageType.svg,
                              fit: BoxFit.fill,
                              height: 120,
                            ),
                          ),
                          Expanded(
                            child: CustomImage(
                              onTap: () => provider.updateGender(Gender.female),
                              path: provider.user!.gender == Gender.female.name ? 'assets/svg/gender/selected_female.svg' : 'assets/svg/gender/un_selected_female.svg',
                              imageType: ImageType.svg,
                              fit: BoxFit.fill,
                              height: 120,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: GestureDetector(
                        onTap: ref.read(profileProvider.notifier).onDeleteAccountTap,
                        child: Row(
                          children: [
                            CustomImage(path: 'assets/svg/trash.svg', imageType: ImageType.svg, height: 25, width: 25, margin: EdgeInsets.only(right: 16)),
                            Text(LocaleKeys.delete_account.tr(), style: CTextStyle.w500(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: GestureDetector(
                        onTap: ref.read(profileProvider.notifier).onLogoutTap,
                        child: Row(
                          children: [
                            CustomImage(path: 'assets/svg/logout.svg', imageType: ImageType.svg, height: 25, width: 25, margin: EdgeInsets.only(right: 16)),
                            Text(LocaleKeys.logout.tr(), style: CTextStyle.w500(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
