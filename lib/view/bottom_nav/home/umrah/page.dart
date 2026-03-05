import '../../../../export.dart';
import '../meeqaat/page.dart';
import '../meeqaat/three_tasks.dart';
import '../meeqaat/two_tasks.dart';
import 'safa_marwa.dart';
import 'sai_completion.dart';
import 'tawaf_tracker.dart';
import 'umrah_completed.dart';

class UmrahPage extends ConsumerStatefulWidget {
  const UmrahPage({super.key, this.userActivityType = UserActivityType.umrah});
  final UserActivityType userActivityType;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartTawafPageState();
}

class _StartTawafPageState extends ConsumerState<UmrahPage> {
  @override
  void initState() {
    super.initState();
    ref.read(umrahProvider.notifier).context = context;
    ref.read(umrahProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(umrahProvider.notifier).initialization(widget.userActivityType);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(umrahProvider);
    ref.read(umrahProvider.notifier).context = context;
    ref.read(umrahProvider.notifier).ref = ref;
    if (provider.isLoading) {
      return Background(child: const Loading());
    } else if (!provider.hasDoneBeforeMeeqaatTasks) {
      return MeeqaatTwoTasksPage();
    } else if (!provider.hasReachedMeeqaat) {
      return MeeqaatPage();
    } else if (!provider.hasDoneAfterMeeqaatTasks) {
      return MeeqaatThreeTasksPage();
    } else if (provider.isUmrahCompleted) {
      return UmrahCompleted();
    } else if (provider.isSafaMarwaComplete) {
      return SaiCompletionPage();
    } else if (!provider.showSafaMarwa) {
      return TawafTrackerPage();
    } else {
      return SafaMarwaPage();
    }
  }
}
