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
      backgroundType: BackgroundType.logoWithSkip,
      titleAlignment: Alignment.center,
      onSkipTap: ref.read(locationPermissionProvider.notifier).skip,
      titleMargin: SizeConfig.only(top: 60, bottom: 40),
      child: Column(
        children: [
          Padding(padding: SizeConfig.only(top: 32), child: FormattedText(rawText: LocaleKeys.permission_request_message.tr())),
          CButton(margin: SizeConfig.only(top: 48), title: LocaleKeys.turn_on_location.tr(), fontSize: 14, onTap: ref.read(locationPermissionProvider.notifier).continueTab),
        ],
      ),
    );
  }
}
