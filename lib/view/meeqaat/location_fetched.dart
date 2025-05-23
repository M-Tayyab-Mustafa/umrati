import '../../controller/meeqaat/location_fetch_provider.dart';
import '../../export.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/marker.dart';

class MeeqaatLocationFetchedPage extends ConsumerWidget {
  const MeeqaatLocationFetchedPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(locationFetchProvider.notifier);
    return Background(
      backgroundType: BackgroundType.logoWithSkip,
      title: '${LocaleKeys.your_meeqaat_location.tr()}:',
      titleMargin: EdgeInsets.only(top: 60, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.dhul_huayfah.tr(), style: CTextStyle.w400(color: CColors.primary, fontSize: 20)),
          Padding(padding: const EdgeInsets.only(top: 10, bottom: 20), child: TimeLine(items: ['9 Km', '15 minutes'])),
          Text('${LocaleKeys.your_current_location.tr()}:', style: CTextStyle.w500(fontSize: 22)),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: FutureBuilder(
              future: provider.getLocation(),
              builder: (context, snapshot) {
                return Text(provider.location, style: CTextStyle.w500());
              },
            ),
          ),
          CButton(title: LocaleKeys.continue_your_remaining_3_tasks.tr(), fontSize: 14, onTap: () => provider.continueTab(context)),
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
