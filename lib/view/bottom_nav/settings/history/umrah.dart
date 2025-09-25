import '../../../../export.dart';

class UmrahHistoryPage extends ConsumerStatefulWidget {
  const UmrahHistoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UmrahHistoryPageState();
}

class _UmrahHistoryPageState extends ConsumerState<UmrahHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(historyProvider);
    return Background(
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16, bottom: kToolbarHeight / 2),
      backgroundType: BackgroundType.titleWithBackButton,
      logoAlign: Alignment.center,
      title: LocaleKeys.umra.tr(),
      child:
          provider.isLoading
              ? Loading()
              : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ListView.builder(
                  itemCount: provider.umrahHistories.length,
                  itemBuilder: (context, index) {
                    var histories = provider.umrahHistories.values.toList()[index];
                    var time = provider.umrahHistories.keys.toList()[index];
                    return HistoryCard(histories: histories, time: time);
                  },
                ),
              ),
    );
  }
}
