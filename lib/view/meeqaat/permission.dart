import '../../export.dart';

class LocationPermissionPage extends ConsumerWidget {
  const LocationPermissionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(meeqaatPermissionProvider);
    return Background(
      backgroundType: BackgroundType.logoWithSkip,
      title: LocaleKeys.your_meeqaat_location.tr(),
      titleAlignment: Alignment.center,
      onSkipTap: () => provider.skip(context),
      titleMargin: EdgeInsets.only(top: 60, bottom: 40),
      child: Align(alignment: Alignment.topCenter, child: CButton(title: LocaleKeys.turn_on_your_location_to_find_your_meeqaat.tr(), fontSize: 14, onTap: () => provider.continueTab(context))),
    );
  }
}
