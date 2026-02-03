import '../../export.dart';

final subscriptionProvider = ChangeNotifierProvider.autoDispose<SubscriptionProviderNotifier>((ref) => SubscriptionProviderNotifier());

class SubscriptionProviderNotifier extends ChangeNotifier {
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

  Future<void> getSubscriptionPlans(BuildContext context) async {
    try {
      user = (await LocalStorageManager.getUser())!;
      userRegion = await Helper.getCurrencySymbol();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
      docs = (await plansCollection.where(Filter('regions', arrayContains: userRegion)).get()).docs;
      if (docs.isEmpty) {
        docs = (await plansCollection.where(Filter('regions', isEqualTo: [])).get()).docs;
      }
      plans = docs.map((planDoc) => PlanModel.fromMap(planDoc.data())).toList()..sort((a, b) => a.amount.compareTo(b.amount));
      await Future.delayed(const Duration(milliseconds: 400));
      plans = await Helper.loadProducts(plans: plans);
      selectedPlan = plans.first;
      isLoading = false;
      if (context.mounted) notifyListeners();
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
    Helper.listenPurchases((purchase) async {
      if (purchase.pendingCompletePurchase) {
        await Helper.iap.completePurchase(purchase);
      }
      await _subscribePlan(context);
    });
  }

  Future<void> subscribe() async {
    // if (Payment.instance.paymentSetting!.showGooglePayButton == false &&
    //     Payment.instance.paymentSetting!.showApplePayButton == false &&
    //     Payment.instance.paymentSetting!.showJazzCashButton == false &&
    //     Payment.instance.paymentSetting!.showEasyPaisaButton == false &&
    //     Payment.instance.paymentSetting!.showStripeButton == false) {
    //   errorToast('Current payment gateway is not available. Please try again later.');
    // } else {
    // panelController.anchor();
    if (!(await Helper.iap.isAvailable())) {
      appLog(LocaleKeys.in_app_purchase_not_available.tr());
      errorToast(LocaleKeys.in_app_purchase_not_available.tr());
      return;
    }
    if (selectedPlan.productDetails == null) {
      appLog(LocaleKeys.selected_plan_not_available.tr());
      errorToast(LocaleKeys.selected_plan_not_available.tr());
      return;
    }

    await Helper.iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: selectedPlan.productDetails!));
    // }
  }

  void selectPlan(PlanModel plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  FutureOr<void> onPaymentResult(Map<String, dynamic> result, BuildContext context) async => await _subscribePlan(context);

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

  Future<void> _subscribePlan(BuildContext context) async {
    isSubscribing = true;
    notifyListeners();
    try {
      final query = subscriptionCollection.where(Filter('user_ids', arrayContains: user.uid)).limit(1);
      DocumentReference<Map<String, dynamic>> doc;
      if ((await query.get()).docs.isNotEmpty) {
        doc = (await query.get()).docs.first.reference;
        var userIds = List<String>.from((await doc.get()).get('user_ids'));
        await doc.set(SubscriptionModel(uid: doc.id, user_ids: userIds, plan: selectedPlan).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp(), expire_at: FieldValue.serverTimestamp()));
        final expireAt = (await doc.get()).get('expire_at') as Timestamp;
        await doc.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(expireAt.toDate().add(Duration(days: selectedPlan.duration)).millisecondsSinceEpoch)});
        infoToast('Plan Updated Successfully');
      } else {
        doc = subscriptionCollection.doc();
        await doc.set(SubscriptionModel(uid: doc.id, user_ids: [user.uid], plan: selectedPlan).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp(), expire_at: FieldValue.serverTimestamp()));
        final expireAt = (await doc.get()).get('expire_at') as Timestamp;
        await doc.update({'expire_at': Timestamp.fromMillisecondsSinceEpoch(expireAt.toDate().add(Duration(days: selectedPlan.duration)).millisecondsSinceEpoch)});
        infoToast('Plan Subscribed Successfully');
      }
      Helper.userSubscription = SubscriptionModel.fromMap((await doc.get()).data()!);
      await LocalStorageManager.saveUser(user.copyWith(subscription_id: doc.id, is_premium: true));
      Navigator.canPop(context);
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
      isSubscribing = false;
      notifyListeners();
    }
  }

  Future<void> enterKeyDialog(BuildContext context, WidgetRef ref) async {
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
        enterKeyDialog(context, ref);
        isSubscribing = false;
        notifyListeners();
        return;
      }
      var subscription = SubscriptionModel.fromMap(docs.first.data());
      if (subscription.user_ids.length == subscription.plan.members) {
        errorToast(LocaleKeys.key_limit_reached.tr());
        enterKeyDialog(context, ref);
        isSubscribing = false;
        notifyListeners();
        return;
      }
      bool isExpired = DateTime.now().isAfter(subscription.expire_at!.toDate());
      if (isExpired) {
        errorToast(LocaleKeys.subscription_expire_msg.tr());
        enterKeyDialog(context, ref);
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
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
      isSubscribing = false;
      notifyListeners();
    }
  }

  Future<void> onJazzCashTap(BuildContext context) async {
    isSubscribing = true;
    isLoadingJazzCashPaymentMethod = true;
    notifyListeners();
    try {
      await Payment.instance.makePaymentByJazzCash(context: context, userRegion: userRegion, amount: selectedPlan.amount.toString(), onSuccess: () => _subscribePlan(context));
      panelController.collapse();
    } catch (e) {
      log(e.toString());
    }
    isLoadingJazzCashPaymentMethod = false;
    isSubscribing = false;
    notifyListeners();
  }

  Future<void> onEasyPaisaTap(BuildContext context) async {
    isLoadingEasyPaisaPaymentMethod = true;
    notifyListeners();
    try {
      await Payment.instance.makePaymentByEasyPaisa(context: context, userRegion: userRegion, amount: selectedPlan.amount.toString(), onSuccess: () => _subscribePlan(context));
      panelController.collapse();
    } catch (e) {
      log(e.toString());
    }
    isLoadingEasyPaisaPaymentMethod = false;
    isSubscribing = false;
    notifyListeners();
  }

  Future<void> onCardTab(BuildContext context) async {
    isLoadingStripePaymentMethod = true;
    notifyListeners();
    try {
      await Payment.instance.makeStripePayment(userRegion: userRegion, amount: selectedPlan.amount.toString(), onSuccess: () => _subscribePlan(context));
      panelController.collapse();
    } catch (e) {
      log(e.toString());
    }
    isLoadingStripePaymentMethod = false;
    isSubscribing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    panelController.dispose();
    Helper.disposeInAppPurchaseSubscription();
    super.dispose();
  }
}
