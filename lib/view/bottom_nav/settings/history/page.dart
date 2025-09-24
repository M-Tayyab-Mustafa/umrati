import '../../../../export.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    super.initState();
    ref.read(historyProvider.notifier).context = context;
    ref.read(historyProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(historyProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16, bottom: kToolbarHeight / 2),
      logoAlign: Alignment.center,
      title: LocaleKeys.history.tr(),
      backgroundType: BackgroundType.titleWithBackButton,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            HistoryCard(
              margin: EdgeInsets.only(bottom: 24),
              onTap: ref.read(historyProvider.notifier).onUmraTap,
              image: 'assets/png/history/umrah.png',
              title: LocaleKeys.umra.tr(),
              description: '${LocaleKeys.see_history_of_your.tr()} ${LocaleKeys.umra.tr()}',
            ),
            HistoryCard(
              margin: EdgeInsets.only(bottom: 24),
              onTap: ref.read(historyProvider.notifier).onTawafTap,
              image: 'assets/png/history/tawaf.png',
              title: LocaleKeys.tawaf.tr(),
              description: '${LocaleKeys.see_history_of_your.tr()} ${LocaleKeys.tawaf.tr()}',
            ),
            HistoryCard(
              margin: EdgeInsets.only(bottom: 24),
              onTap: ref.read(historyProvider.notifier).onZiaratTap,
              image: 'assets/png/history/ziarat.png',
              title: LocaleKeys.ziarat.tr(),
              description: '${LocaleKeys.see_history_of_your.tr()} ${LocaleKeys.ziarat.tr()}',
            ),
          ],
        ),
      ),
    );
  }
}
