import '../../export.dart';

class LocationPermissionPage extends ConsumerWidget {
  const LocationPermissionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(locationPermissionProvider);
    return Background(
      backgroundType: BackgroundType.logoWithSkip,
      titleAlignment: Alignment.center,
      onSkipTap: () => provider.skip(context, ref),
      titleMargin: EdgeInsets.only(top: 60, bottom: 40),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 32), child: FormattedText(rawText: LocaleKeys.permission_request_message.tr())),
          CButton(margin: EdgeInsets.only(top: 48), title: LocaleKeys.turn_on_location.tr(), fontSize: 14, onTap: () => provider.continueTab(context, ref)),
        ],
      ),
    );
  }
}
