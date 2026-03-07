import '../../../export.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
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
      margin: context.edgeInsets(left: 16, right: 16, bottom: 50),
      child:
          provider.isLoading
              ? const Loading()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AvatarSection(provider: provider),
                    if (provider.user!.is_premium) _PremiumBadge(provider: provider),
                    _UmrahCountRow(total: provider.user!.total_umrah_done),
                    RepaintBoundary(child: CTextField(margin: context.edgeInsets(vertical: 20), controller: provider.emailController, labelText: LocaleKeys.email.tr(), readOnly: true)),
                    RepaintBoundary(
                      child: CTextField(
                        onTap: provider.updateName,
                        controller: provider.nameController,
                        labelText: LocaleKeys.name.tr(),
                        readOnly: true,
                        suffixIcon: CustomImage(path: 'assets/svg/edit.svg', imageType: ImageType.svg, size: context.r(20)),
                      ),
                    ),
                    Padding(padding: context.edgeInsets(top: 20), child: Text(LocaleKeys.select_your_gender.tr(), style: CTextStyle.w500(fontSize: 17))),
                    _GenderSelector(provider: provider),
                    _ActionRow(icon: 'assets/svg/trash.svg', label: LocaleKeys.delete_account.tr(), onTap: ref.read(profileProvider.notifier).onDeleteAccountTap),
                    _ActionRow(icon: 'assets/svg/logout.svg', label: LocaleKeys.logout.tr(), onTap: ref.read(profileProvider.notifier).onLogoutTap, topPadding: 22, bottomPadding: 20),
                  ],
                ),
              ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.provider});
  final ProfileNotifier provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: context.edgeInsets(top: 16),
        height: context.r(120),
        width: context.r(120),
        child: Stack(
          children: [
            Center(
              child: CustomImage(
                enableBorder: true,
                border: Border.all(color: CColors.primary, width: 2),
                borderRadius: BorderRadius.circular(context.r(160)),
                height: context.r(100),
                width: context.r(100),
                path: provider.user!.photo.isNotEmpty ? provider.user!.photo : provider.localImagePath,
                imageType: provider.user!.photo.isNotEmpty ? ImageType.network : ImageType.png,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: provider.onProfileImageTap,
                child: Container(
                  height: context.h(20),
                  width: context.w(40),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white),
                  child: CustomImage(path: 'assets/svg/camera.svg', imageType: ImageType.svg, size: context.r(15), fit: BoxFit.scaleDown),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge({required this.provider});
  final ProfileNotifier provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: context.edgeInsets(top: 16),
            padding: context.edgeInsets(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: CColors.paleYellow, borderRadius: BorderRadius.circular(32)),
            child: Text(LocaleKeys.premium.tr(), style: CTextStyle.w500(fontSize: 14)),
          ),
          if (provider.daysRemaining < 4)
            Padding(
              padding: context.edgeInsets(top: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(alignment: PlaceholderAlignment.middle, child: Text('${provider.daysRemaining} ${LocaleKeys.days_of_premium_remaining.tr()}  ', style: CTextStyle.w400(fontSize: 12))),
                    if (!Platform.isIOS) WidgetSpan(alignment: PlaceholderAlignment.middle, child: GestureDetector(onTap: provider.renew, child: Text(LocaleKeys.renew.tr(), style: CTextStyle.w500()))),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _UmrahCountRow extends StatelessWidget {
  const _UmrahCountRow({required this.total});
  final num total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.edgeInsets(vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text('$total  ', style: CTextStyle.w900(fontSize: 25, color: CColors.primary)), Expanded(child: Text(LocaleKeys.number_of_umrah_done.tr(), style: CTextStyle.w400(fontSize: 18, color: CColors.deepTeal)))],
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({required this.provider});
  final ProfileNotifier provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.edgeInsets(top: 8, bottom: 16),
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
              size: context.r(100),
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
              size: context.r(100),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label, required this.onTap, this.topPadding = 0, this.bottomPadding = 0});

  final String icon;
  final String label;
  final VoidCallback onTap;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.edgeInsets(top: topPadding, bottom: bottomPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Row(children: [CustomImage(path: icon, imageType: ImageType.svg, size: context.r(20), margin: context.edgeInsets(right: isLTR(context) ? 16 : 0, left: isLTR(context) ? 0 : 16)), Text(label, style: CTextStyle.w500())]),
      ),
    );
  }
}
