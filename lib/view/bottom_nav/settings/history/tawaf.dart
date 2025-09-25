import '../../../../export.dart';

class TawafHistoryPage extends ConsumerStatefulWidget {
  const TawafHistoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TawafHistoryPageState();
}

class _TawafHistoryPageState extends ConsumerState<TawafHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).initialization(fromUmrah: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(historyProvider);
    return Background(
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16, bottom: kToolbarHeight / 2),
      backgroundType: BackgroundType.titleWithBackButton,
      logoAlign: Alignment.center,
      title: LocaleKeys.tawaf.tr(),
      child:
          provider.isLoading
              ? Loading()
              : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ListView.builder(
                  itemCount: provider.tawafHistories.length,
                  itemBuilder: (context, index) {
                    var histories = provider.tawafHistories.values.toList()[index];
                    var time = provider.tawafHistories.keys.toList()[index];
                    return HistoryCard(histories: histories, time: time);
                  },
                ),
              ),
    );
  }
}
