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
    ref.read(historyProvider.notifier).context = context;
    ref.read(historyProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).initialization(historyType: HistoryType.tawaf);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(historyProvider);
    return Background(
      margin: ScaledEdgeInsets.zero,
      backgroundType: BackgroundType.titleWithBackButton,
      logoAlign: Alignment.center,
      title: LocaleKeys.tawaf.tr(),
      child:
          provider.isLoading
              ? Loading()
              : provider.tawafHistories.isEmpty
              ? Center(child: Text(LocaleKeys.no_history_found.tr(), style: CTextStyle.w500(fontSize: 22), textAlign: TextAlign.center))
              : ListView.builder(
                padding: ScaledEdgeInsets.zero,
                itemCount: provider.tawafHistories.length,
                itemBuilder: (context, index) {
                  var histories = provider.tawafHistories.values.toList()[index];
                  var time = provider.tawafHistories.keys.toList()[index];
                  return HistoryCard(histories: histories, time: time);
                },
              ),
    );
  }
}
