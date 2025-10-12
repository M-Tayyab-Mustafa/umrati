import '../../export.dart';

final subscriptionProvider = ChangeNotifierProvider.autoDispose<SubscriptionProviderNotifier>((ref) => SubscriptionProviderNotifier());

class SubscriptionProviderNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  bool isRenewingPlan = false;

  bool isLoading = true;
  bool isSubscribing = false;

  bool isLoadingJazzCashPaymentMethod = false;
  bool isLoadingEasyPaisaPaymentMethod = false;
  bool isLoadingStripePaymentMethod = false;

  List<PlanModel> plans = [];
  late PlanModel selectedPlan;
  late UserModel user;
  final panelController = SlidingUpPanelController(value: SlidingUpPanelStatus.collapsed);
  bool showThreeMonthPlans = true;
  final TextEditingController keyController = TextEditingController();
  String userRegion = 'US';

  Future<void> getSubscriptionPlans() async {
    try {
      user = (await LocalStorageManager.getUser())!;
      userRegion = await Helper.userRegion();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
      docs = (await plansCollection.where(Filter('regions', arrayContains: userRegion)).get()).docs;
      if (docs.isEmpty) {
        docs = (await plansCollection.where(Filter('regions', isEqualTo: [])).get()).docs;
      }
      plans = docs.map((planDoc) => PlanModel.fromMap(planDoc.data())).toList()..sort((a, b) => a.amount.compareTo(b.amount));
      await Future.delayed(const Duration(milliseconds: 400));
      selectedPlan = plans.first;
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
      panelController.anchor();
      isSubscribing = false;
      notifyListeners();
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
      data = plans.where((element) => element.duration == 90).toList();
    } else {
      data = plans.where((element) => element.duration != 90).toList();
    }
    if (data.isNotEmpty) selectedPlan = data.first;
    notifyListeners();
  }

  Future<void> _subscribePlan() async {
    isSubscribing = true;
    notifyListeners();
    try {
      final query = subscriptionCollection.where(Filter('user_ids', arrayContains: user.uid)).limit(1);
      DocumentReference<Map<String, dynamic>> doc;
      if ((await query.get()).docs.isNotEmpty) {
        doc = (await query.get()).docs.first.reference;
        var userIds = List<String>.from((await doc.get()).get('user_ids'));
        await doc.set(
          SubscriptionModel(
            uid: doc.id,
            user_ids: userIds,
            plan: selectedPlan,
          ).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp(), expire_at: FieldValue.serverTimestamp()),
        );
        final expireAt = (await doc.get()).get('expire_at') as Timestamp;
        await doc.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(expireAt.toDate().add(Duration(days: selectedPlan.duration)).millisecondsSinceEpoch)});
        infoToast('Plan Updated Successfully');
      } else {
        doc = subscriptionCollection.doc();
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
      await LocalStorageManager.saveUser(user.copyWith(subscription_id: doc.id, is_premium: true));
      ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
      isSubscribing = false;
      notifyListeners();
    }
  }

  Future<void> enterKeyDialog() async {
    keyController.clear();
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => PlanKeyDialog(controller: keyController));
    if (result != true) return;
    try {
      isSubscribing = true;
      notifyListeners();
      final query = subscriptionCollection.where('uid', isEqualTo: keyController.text.trim());
      final docs = (await query.get()).docs;
      if (docs.isEmpty) {
        errorToast(LocaleKeys.invalid_key.tr());
        enterKeyDialog();
        isSubscribing = false;
        notifyListeners();
        return;
      }
      var subscription = SubscriptionModel.fromMap(docs.first.data());
      if (subscription.user_ids.length == subscription.plan.members) {
        errorToast(LocaleKeys.key_limit_reached.tr());
        enterKeyDialog();
        isSubscribing = false;
        notifyListeners();
        return;
      }
      bool isExpired = DateTime.now().isAfter(subscription.expire_at!.toDate());
      if (isExpired) {
        errorToast(LocaleKeys.subscription_expire_msg.tr());
        enterKeyDialog();
        isSubscribing = false;
        notifyListeners();
        return;
      }
      await docs.first.reference.update({
        'user_ids': FieldValue.arrayUnion([user.uid]),
        'updated_at': FieldValue.serverTimestamp(),
      });
      infoToast('Plan Subscribed Successfully');
      Helper.userSubscription = SubscriptionModel.fromMap((await docs.first.reference.get()).data()!);
      await LocalStorageManager.saveUser(user.copyWith(subscription_id: subscription.uid));
      ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
      isSubscribing = false;
      notifyListeners();
    }
  }

  Future<void> onJazzCashTap() async {
    isLoadingJazzCashPaymentMethod = true;
    notifyListeners();
    await Payment.instance.makePaymentByJazzCash(context: context, userRegion: userRegion, amount: selectedPlan.amount.toString(), onSuccess: _subscribePlan);
    panelController.collapse();
    isLoadingJazzCashPaymentMethod = false;
    notifyListeners();
  }

  Future<void> onEasyPaisaTap() async {
    isLoadingEasyPaisaPaymentMethod = true;
    notifyListeners();
    await Payment.instance.makePaymentByEasyPaisa(context: context, userRegion: userRegion, amount: selectedPlan.amount.toString(), onSuccess: _subscribePlan);
    panelController.collapse();
    isLoadingEasyPaisaPaymentMethod = false;
    notifyListeners();
  }

  Future<void> onCardTab() async {
    isLoadingStripePaymentMethod = true;
    notifyListeners();
    await Payment.instance.makeStripePayment(userRegion: userRegion, amount: selectedPlan.amount.toString(), onSuccess: _subscribePlan);
    panelController.collapse();
    isLoadingStripePaymentMethod = false;
    notifyListeners();
  }

  @override
  void dispose() {
    panelController.dispose();
    super.dispose();
  }
}
