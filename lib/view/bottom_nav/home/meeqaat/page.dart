import '../../../../export.dart';

class MeeqaatPage extends ConsumerStatefulWidget {
  const MeeqaatPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeeqaatPageState();
}

class _MeeqaatPageState extends ConsumerState<MeeqaatPage> {
  @override
  void initState() {
    super.initState();
    final provider = ref.read(locationFetchProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) => provider.getLocation());
    provider.context = context;
    provider.ref = ref;
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(locationFetchProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      titleType: TitleType.backArrow,
      margin: context.edgeInsets(top: MediaQuery.sizeOf(context).height * 0.1, left: 16, right: 16),
      title: '${LocaleKeys.distance_from_meeqaat.tr()}:',
      titleMargin: context.edgeInsets(top: kToolbarHeight * 0.5, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.dhul_huayfah.tr(), style: CTextStyle.w400(color: CColors.primary, fontSize: 18)),
          Padding(padding: context.edgeInsets(top: 10, bottom: 20), child: TimeLine(items: [(provider.distance ?? '0 km'), (provider.time ?? '0 min')])),
          Text('${LocaleKeys.your_current_location.tr()}:', style: CTextStyle.w500(fontSize: 18)),
          Padding(padding: context.edgeInsets(top: 10, bottom: 30), child: Text(provider.location, style: CTextStyle.w400(fontSize: 15))),
          Center(child: CButton(isLoading: provider.isLoading, title: LocaleKeys.continue_your_remaining_3_tasks.tr(), fontSize: 14, onTap: ref.read(locationFetchProvider.notifier).onContinueYourRemainingTasks)),
        ],
      ),
    );
  }
}

class TimeLine extends StatelessWidget {
  const TimeLine({super.key, required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(children: items.map((item) => CMarker(title: item, color: Colors.transparent, titleColor: CColors.primary, textDirection: TextDirection.ltr)).toList());
  }
}
