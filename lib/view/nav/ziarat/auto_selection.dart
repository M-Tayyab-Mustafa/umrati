part of 'page.dart';

class AutoSelection extends ConsumerWidget {
  const AutoSelection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaratProvider);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 16), child: Text('${LocaleKeys.your_current_location.tr()}:', style: CTextStyle.w500(fontSize: 22))),
          FutureBuilder(
            future: provider.getLocation(),
            builder: (context, snapshot) {
              return Text('${snapshot.hasData ? snapshot.data : ''}', style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal));
            },
          ),
          Padding(padding: const EdgeInsets.only(top: 16), child: Text(LocaleKeys.your_ziarat_destinations.tr(), style: CTextStyle.w500(fontSize: 20))),
          Expanded(
            child: FutureBuilder(
              future: provider.getDistance(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: provider.ziarats.length,
                  itemBuilder: (context, index) {
                    var ziarat = provider.ziarats[index];
                    return CMarker(title: ziarat.title, distance: ziarat.distance);
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              children: [
                CButton(
                  onTap: provider.goToAutoSelectionPage,
                  title: LocaleKeys.go_back.tr(),
                  backgroundColor: Colors.transparent,
                  borderColor: CColors.primary,
                  titleColor: CColors.primary,
                  shadows: [],
                ),
                Spacer(),
                CButton(onTap: () => provider.createZiaratRoute(context), title: LocaleKeys.start_your_ziarat.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
