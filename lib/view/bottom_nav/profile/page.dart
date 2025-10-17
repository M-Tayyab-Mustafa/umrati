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
      titleStyle: CTextStyle.w500(fontSize: 22, letterSpacing: 2),
      margin: SizeConfig.only(left: 16, right: 16, bottom: 50),
      child:
          provider.isLoading
              ? Loading()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: SizeConfig.only(top: 32),
                        height: SizeConfig.h(120),
                        width: SizeConfig.h(120),
                        child: Stack(
                          children: [
                            Center(
                              child: CustomImage(
                                enableBorder: true,
                                border: Border.all(color: CColors.primary, width: 2),
                                borderRadius: BorderRadius.circular(160),
                                height: SizeConfig.h(100),
                                width: SizeConfig.h(100),
                                path: provider.user!.photo.isNotEmpty ? provider.user!.photo : provider.localImagePath,
                                imageType: provider.user!.photo.isNotEmpty ? ImageType.network : ImageType.png,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: ref.read(profileProvider.notifier).onProfileImageTap,
                                child: Container(
                                  height: SizeConfig.h(20),
                                  width: SizeConfig.w(40),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white),
                                  child: CustomImage(path: 'assets/svg/camera.svg', imageType: ImageType.svg, size: SizeConfig.w(15), fit: BoxFit.scaleDown),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (provider.user!.is_premium)
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: SizeConfig.only(top: 16),
                              padding: SizeConfig.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: CColors.paleYellow, borderRadius: BorderRadius.circular(32)),
                              child: Text(LocaleKeys.premium.tr(), style: CTextStyle.w500(fontSize: 14)),
                            ),
                            if (provider.daysRemaining < 4)
                              Padding(
                                padding: SizeConfig.only(top: 8),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Text('${provider.daysRemaining} ${LocaleKeys.days_of_premium_remaining.tr()}  ', style: CTextStyle.w400(fontSize: 12)),
                                      ),
                                      WidgetSpan(alignment: PlaceholderAlignment.middle, child: GestureDetector(onTap: provider.renew, child: Text(LocaleKeys.renew.tr(), style: CTextStyle.w500()))),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: SizeConfig.symmetric(vertical: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${provider.user!.total_umrah_done}  ', style: CTextStyle.w900(fontSize: 25, color: CColors.primary)),
                          Expanded(child: Text(LocaleKeys.number_of_umrah_done.tr(), style: CTextStyle.w400(fontSize: 18, color: CColors.deepTeal))),
                        ],
                      ),
                    ),
                    PhoneNumberTextField(controller: provider.numberController, readOnly: true),
                    CTextField(margin: SizeConfig.symmetric(vertical: 20), controller: provider.emailController, labelText: LocaleKeys.email.tr(), readOnly: true),
                    CTextField(
                      onTap: provider.updateName,
                      controller: provider.nameController,
                      labelText: LocaleKeys.name.tr(),
                      readOnly: true,
                      suffixIcon: CustomImage(path: 'assets/svg/edit.svg', imageType: ImageType.svg, size: SizeConfig.w(20)),
                    ),
                    Padding(padding: SizeConfig.only(top: 20), child: Text(LocaleKeys.select_your_gender.tr(), style: CTextStyle.w500(fontSize: 17))),
                    Padding(
                      padding: SizeConfig.only(top: 8, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomImage(
                              onTap: () => provider.updateGender(Gender.male),
                              path:
                                  provider.user!.gender == Gender.male.name
                                      ? isLTR(context)
                                          ? 'assets/svg/gender/selected_male.svg'
                                          : 'assets/svg/gender/selected_male_ur.svg'
                                      : isLTR(context)
                                      ? 'assets/svg/gender/un_selected_male.svg'
                                      : 'assets/svg/gender/un_selected_male_ur.svg',
                              imageType: ImageType.svg,
                              fit: BoxFit.fill,
                              size: SizeConfig.h(100),
                            ),
                          ),
                          Expanded(
                            child: CustomImage(
                              onTap: () => provider.updateGender(Gender.female),
                              path:
                                  provider.user!.gender == Gender.female.name
                                      ? isLTR(context)
                                          ? 'assets/svg/gender/selected_female.svg'
                                          : 'assets/svg/gender/selected_female_ur.svg'
                                      : isLTR(context)
                                      ? 'assets/svg/gender/un_selected_female.svg'
                                      : 'assets/svg/gender/un_selected_female_ur.svg',
                              imageType: ImageType.svg,
                              fit: BoxFit.fill,
                              size: SizeConfig.h(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: ref.read(profileProvider.notifier).onDeleteAccountTap,
                      child: Row(
                        children: [
                          CustomImage(
                            path: 'assets/svg/trash.svg',
                            imageType: ImageType.svg,
                            size: SizeConfig.w(20),
                            margin: SizeConfig.only(right: isLTR(context) ? 16 : 0, left: isLTR(context) ? 0 : 16),
                          ),
                          Text(LocaleKeys.delete_account.tr(), style: CTextStyle.w500()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: SizeConfig.only(top: 22, bottom: 20),
                      child: GestureDetector(
                        onTap: ref.read(profileProvider.notifier).onLogoutTap,
                        child: Row(
                          children: [
                            CustomImage(
                              path: 'assets/svg/logout.svg',
                              imageType: ImageType.svg,
                              size: SizeConfig.w(20),
                              margin: SizeConfig.only(right: isLTR(context) ? 16 : 0, left: isLTR(context) ? 0 : 16),
                            ),
                            Text(LocaleKeys.logout.tr(), style: CTextStyle.w500()),
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
