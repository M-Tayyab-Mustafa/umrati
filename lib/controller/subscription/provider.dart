import '../../export.dart';

final subscriptionProvider = ChangeNotifierProvider.autoDispose<SubscriptionProviderNotifier>((ref) => SubscriptionProviderNotifier());

class SubscriptionProviderNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  bool isLoading = true;
  bool isSubscribing = false;
  List<PlanModel> plans = [];
  late PlanModel selectedPlan;
  late UserModel user;
  final panelController = SlidingUpPanelController(value: SlidingUpPanelStatus.collapsed);
  bool showThreeMonthPlans = true;
  final TextEditingController keyController = TextEditingController();

  Future<void> getSubscriptionPlans() async {
    try {
      user = (await LocalStorageManager.getUser())!;
      var userRegion = await Helper.userRegion();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
      docs = (await plansCollection.where(Filter.or(Filter('type', isEqualTo: PlanType.free.name), Filter('regions', arrayContains: userRegion))).get()).docs;
      if (docs.length <= 1) {
        docs = (await plansCollection.where(Filter.or(Filter('type', isEqualTo: PlanType.free.name), Filter('regions', isEqualTo: []))).get()).docs;
      }
      plans = docs.map((planDoc) => PlanModel.fromMap(planDoc.data())).toList()..sort((a, b) => a.amount.compareTo(b.amount));
      await Future.delayed(const Duration(milliseconds: 400));
      selectedPlan = plans.firstWhere((e) => e.type == PlanType.free.name);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  Future<void> subscribe() async {
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

  FutureOr<void> onPaymentResult(Map<String, dynamic> result) async => await _subscribePlan();

  FutureOr<void> togglePlans(bool value) async {
    showThreeMonthPlans = !value;
    var data = <PlanModel>[];
    if (showThreeMonthPlans) {
      data = plans.where((element) => element.duration == 90 || element.type == PlanType.free.name).toList();
    } else {
      data = plans.where((element) => element.duration != 90 && element.type != PlanType.free.name).toList();
    }
    if (data.isNotEmpty) selectedPlan = data.first;
    notifyListeners();
  }

  Future<void> _subscribePlan() async {
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
      await doc.set(
        SubscriptionModel(
          uid: doc.id,
          user_ids: [user.uid],
          plan: selectedPlan,
        ).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp(), expire_at: FieldValue.serverTimestamp()),
      );
      final expireAt = (await doc.get()).get('expire_at') as Timestamp;
      await doc.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(expireAt.toDate().add(Duration(days: selectedPlan.duration)).millisecondsSinceEpoch)});
      infoToast('Plan Subscribed Successfully');
    }
    Helper.userSubscription = SubscriptionModel.fromMap((await doc.get()).data()!);
    await LocalStorageManager.saveUser(user.copyWith(subscription_id: doc.id));
    ref.read(splashProvider.notifier).redirections(context, false);
  }

  Future<void> enterKeyDialog() async {
    keyController.clear();
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => PlanKeyDialog(controller: keyController));
    if (result != true) return;
    isSubscribing = true;
    notifyListeners();
    try {
      final query = FirebaseFirestore.instance.collection(CollectionNames.subscriptions.name).where('uid', isEqualTo: keyController.text.trim());
      final docs = (await query.get()).docs;
      if (docs.isEmpty) {
        errorToast(LocaleKeys.invalid_key.tr());
        enterKeyDialog();
        return;
      }
      var subscription = SubscriptionModel.fromMap(docs.first.data());
      if (subscription.user_ids.length == subscription.plan.members) {
        errorToast(LocaleKeys.key_limit_reached.tr());
        enterKeyDialog();
        return;
      }
      bool isExpired = DateTime.now().isAfter(subscription.expire_at!.toDate());
      if (isExpired) {
        errorToast(LocaleKeys.subscription_expire_msg.tr());
        enterKeyDialog();
        return;
      }
      await docs.first.reference.update({
        'user_ids': FieldValue.arrayUnion([user.uid]),
        'updated_at': FieldValue.serverTimestamp(),
      });
      infoToast('Plan Subscribed Successfully');
      Helper.userSubscription = SubscriptionModel.fromMap((await docs.first.reference.get()).data()!);
      await LocalStorageManager.saveUser(user.copyWith(subscription_id: subscription.uid));
      ref.read(splashProvider.notifier).redirections(context, false);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    } finally {
      isSubscribing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    panelController.dispose();
    super.dispose();
  }
}
