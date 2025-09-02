import '../../export.dart';

final subscriptionProvider = ChangeNotifierProvider.autoDispose<SubscriptionProviderNotifier>((ref) => SubscriptionProviderNotifier());

class SubscriptionProviderNotifier extends ChangeNotifier {
  bool isLoading = true;
  bool isSubscribing = false;
  List<PlanModel> plans = [];
  late PlanModel selectedPlan;
  late UserModel user;
  final panelController = SlidingUpPanelController(value: SlidingUpPanelStatus.collapsed);

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void getSubscriptionPlans() async {
    try {
      user = (await LocalStorageManager.getUser())!;
      plans =
          (await FirebaseFirestore.instance.collection(CollectionNames.plans.name).where(Filter.or(Filter('type', isEqualTo: PlanType.free.name), Filter('is_heigh_tier', isEqualTo: true))).get()).docs
              .map((planDoc) => PlanModel.fromMap(planDoc.data()))
              .toList();
      plans.sort((a, b) => a.amount.compareTo(b.amount));
      await Future.delayed(const Duration(milliseconds: 400));
      selectedPlan = plans.firstWhere((e) => e.type == PlanType.free.name);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  void subscribe() async {
    isSubscribing = true;
    notifyListeners();
    try {
      if (selectedPlan.type == PlanType.free.name) {
        await _subscribePlan();
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

  FutureOr<void> onPaymentResult(Map<String, dynamic> result) async {
    await _subscribePlan();
  }

  _subscribePlan() async {
    final query = FirebaseFirestore.instance.collection(CollectionNames.subscriptions.name).where(Filter('user_ids', arrayContains: user.uid)).limit(1);
    DocumentReference<Map<String, dynamic>> doc;
    if ((await query.get()).docs.isNotEmpty) {
      doc = (await query.get()).docs.first.reference;
      await doc.update({'expire_at': FieldValue.serverTimestamp(), 'updated_at': FieldValue.serverTimestamp()});
      final expireAt = (await doc.get()).get('expire_at') as Timestamp;
      await doc.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(expireAt.toDate().add(Duration(days: selectedPlan.duration)).millisecondsSinceEpoch)});
      infoToast('Plan Updated Successfully');
    } else {
      doc = FirebaseFirestore.instance.collection(CollectionNames.subscriptions.name).doc();
      doc.set(
        SubscriptionModel(
          uid: doc.id,
          user_ids: [user.uid],
          plan: selectedPlan,
        ).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp(), expire_at: FieldValue.serverTimestamp()),
      );
      final expireAt = (await doc.get()).get('expire_at') as Timestamp;
      await doc.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(expireAt.toDate().add(Duration(days: selectedPlan.duration)).millisecondsSinceEpoch)});
    }
    Helper.userSubscription = SubscriptionModel.fromMap((await doc.get()).data()!);
    await LocalStorageManager.saveUser(user.copyWith(subscription_id: doc.id));
    ref.read(splashProvider.notifier).redirections(context, false);
  }

  @override
  void dispose() {
    panelController.dispose();
    super.dispose();
  }
}
