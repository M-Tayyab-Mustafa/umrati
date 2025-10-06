import '../../../../export.dart';
import '../meeqaat/page.dart';
import '../meeqaat/three_tasks.dart';
import '../meeqaat/two_tasks.dart';
import 'safa_marwa.dart';
import 'sai_completion.dart';
import 'tawaf_tracker.dart';
import 'umra_completed.dart';

class UmraPage extends ConsumerStatefulWidget {
  const UmraPage({super.key, this.userActivityType = UserActivityType.umra});
  final UserActivityType userActivityType;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartTawafPageState();
}

class _StartTawafPageState extends ConsumerState<UmraPage> {
  @override
  void initState() {
    super.initState();
    ref.read(umraProvider.notifier).context = context;
    ref.read(umraProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(umraProvider.notifier).initialization(widget.userActivityType);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(umraProvider);
    ref.read(umraProvider.notifier).context = context;
    ref.read(umraProvider.notifier).ref = ref;
    if (!provider.hasDoneBeforeMeeqaatTasks) {
      return MeeqaatTwoTasksPage();
    } else if (!provider.hasReachedMeeqaat) {
      return MeeqaatPage();
    } else if (!provider.hasDoneAfterMeeqaatTasks) {
      return MeeqaatThreeTasksPage();
    } else if (provider.isUmraCompleted) {
      return UmraCompleted();
    } else if (provider.isSafaMarwaComplete) {
      return SaiCompletionPage();
    } else if (!provider.showSafaMarwa) {
      return TawafTrackerPage();
    } else {
      return SafaMarwaPage();
    }
  }
}
