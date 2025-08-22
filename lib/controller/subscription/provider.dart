import '../../export.dart';

final subscriptionProvider = ChangeNotifierProvider.autoDispose<SubscriptionProviderNotifier>((ref) => SubscriptionProviderNotifier());

class SubscriptionProviderNotifier extends ChangeNotifier {
  bool isLoading = true;
  bool isSubscribing = false;
  List<PlanModel> plans = [];
  PlanModel? selectedPlan;
  final panelController = SlidingUpPanelController(value: SlidingUpPanelStatus.collapsed);

  void getSubscriptionPlans() async {
    try {
      var region = await Helper.getUserRegion();
      var plansDoc = await FirebaseFirestore.instance.collection(CollectionNames.settings.name).doc(CommonDoc.plans.name).get();
      plans = List.from(plansDoc.get(region.name)).map((plan) => PlanModel.fromMap(plan)).toList()..insert(0, PlanModel(id: '0', duration: double.infinity, amount: 0));
      selectedPlan = plans.first;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  void subscribe(BuildContext context, WidgetRef ref) async {
    isSubscribing = true;
    notifyListeners();
    try {
      if (selectedPlan == plans.first) {
        var user = await LocalStorageManager.getUser();
        user = user!.copyWith(
          subscription: SubscriptionModel(isFreeSubscribed: true, expire_at: Timestamp.fromMillisecondsSinceEpoch(Timestamp.now().toDate().add(Duration(days: 1)).millisecondsSinceEpoch)),
        );
        await LocalStorageManager.saveUser(user, subscription_created_at: FieldValue.serverTimestamp(), subscription_updated_at: FieldValue.serverTimestamp());
        ref.read(splashProvider.notifier).redirections(context, false);
      } else {
        panelController.anchor();
        isSubscribing = false;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
      isSubscribing = false;
      notifyListeners();
    }
  }

  void selectPlan(PlanModel plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  FutureOr<void> onPaymentResult(Map<String, dynamic> result, BuildContext context, WidgetRef ref) async {
    var user = await LocalStorageManager.getUser();
    user = user!.copyWith(
      subscription: SubscriptionModel(
        isFreeSubscribed: true,
        expire_at: Timestamp.fromMillisecondsSinceEpoch(Timestamp.now().toDate().add(Duration(days: selectedPlan!.duration == 3 ? 90 : 365)).millisecondsSinceEpoch),
      ),
    );
    await LocalStorageManager.saveUser(user, subscription_created_at: FieldValue.serverTimestamp(), subscription_updated_at: FieldValue.serverTimestamp());
    ref.read(splashProvider.notifier).redirections(context, false);
  }

  @override
  void dispose() {
    panelController.dispose();
    super.dispose();
  }
}
