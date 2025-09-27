import '../../../../export.dart';

class ZiaratHistoryPage extends ConsumerStatefulWidget {
  const ZiaratHistoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaratHistoryPageState();
}

class _ZiaratHistoryPageState extends ConsumerState<ZiaratHistoryPage> {
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
      title: LocaleKeys.ziarat.tr(),
      child:
          provider.isLoading
              ? Loading()
              : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: provider.ziaratHistories.length,
                  itemBuilder: (context, index) {
                    return BasicCard(child: Column(children: [Text('data')]));
                  },
                ),
              ),
    );
  }
}
