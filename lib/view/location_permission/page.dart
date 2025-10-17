import '../../export.dart';

class LocationPermissionPage extends ConsumerStatefulWidget {
  const LocationPermissionPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends ConsumerState<LocationPermissionPage> {
  @override
  void initState() {
    super.initState();
    ref.read(locationPermissionProvider.notifier).context = context;
    ref.read(locationPermissionProvider.notifier).ref = ref;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      backgroundType: BackgroundType.logo,
      titleAlignment: Alignment.center,
      onSkipTap: ref.read(locationPermissionProvider.notifier).skip,
      title: LocaleKeys.the_umrati_app_needs_location_access_without_it_it_cant.tr(),
      titleStyle: CTextStyle.w400(fontSize: 20),
      titleMargin: SizeConfig.only(top: 30, bottom: 4, right: 16),
      child: Column(
        children: [
          _basicCard(icon: 'assets/svg/location_permission/tawaf_sai.svg', title: LocaleKeys.track_tawaf_or_sai.tr()),
          _basicCard(icon: 'assets/svg/location_permission/meeqaat.svg', title: LocaleKeys.alert_you_about_how_far_meeqaat_is.tr()),
          _basicCard(icon: 'assets/svg/location_permission/navigation.svg', title: LocaleKeys.provide_accurate_navigation.tr()),
          CButton(
            isLoading: ref.watch(locationPermissionProvider).isLoading,
            margin: SizeConfig.only(top: 48),
            titleWithIcon: true,
            title: LocaleKeys.turn_it_on_to_get_full_support.tr(),
            onTap: ref.read(locationPermissionProvider.notifier).continueTab,
          ),
        ],
      ),
    );
  }

  _basicCard({required String icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [CustomImage(margin: EdgeInsets.only(right: 8), size: SizeConfig.h(30), path: icon, imageType: ImageType.svg), Expanded(child: Text(title, style: CTextStyle.w400(fontSize: 18)))],
      ),
    );
  }
}
