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
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      margin: EdgeInsets.zero,
      logoAlign: Alignment.center,
      title: LocaleKeys.history.tr(),
      backgroundType: BackgroundType.titleWithBackButton,
      child: Padding(
        padding: context.edgeInsets(top: 20, left: 16, right: 16),
        child: Column(
          children: [
            HistoryMenuCard(
              margin: context.edgeInsets(bottom: 24),
              onTap: ref.read(historyProvider.notifier).onUmrahTap,
              image: 'assets/png/history/umrah.png',
              title: LocaleKeys.umrah.tr(),
              description: '${LocaleKeys.see_history_of_your.tr()} ${LocaleKeys.umrah.tr()}',
            ),
            HistoryMenuCard(
              margin: context.edgeInsets(bottom: 24),
              onTap: ref.read(historyProvider.notifier).onTawafTap,
              image: 'assets/png/history/tawaf.png',
              title: LocaleKeys.tawaf.tr(),
              description: '${LocaleKeys.see_history_of_your.tr()} ${LocaleKeys.tawaf.tr()}',
            ),
            HistoryMenuCard(
              margin: context.edgeInsets(bottom: 24),
              onTap: ref.read(historyProvider.notifier).onZiaraatTap,
              image: 'assets/png/history/ziaraat.png',
              title: LocaleKeys.ziaraat.tr(),
              description: '${LocaleKeys.see_history_of_your.tr()} ${LocaleKeys.ziaraat.tr()}',
            ),
          ],
        ),
      ),
    );
  }
}
