import '../../controller/subscription/provider.dart';
import '../../export.dart';

class SubscriptionPlansPage extends ConsumerStatefulWidget {
  const SubscriptionPlansPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends ConsumerState<SubscriptionPlansPage> {
  @override
  void initState() {
    super.initState();
    ref.read(subscriptionProvider.notifier).getSubscriptionPlans();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(subscriptionProvider);
    return Background(
      backgroundType: BackgroundType.logo,
      margin: EdgeInsets.only(top: kToolbarHeight / 2),
      logoAlign: Alignment.topCenter,
      child:
          provider.isLoading
              ? Loading()
              : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: provider.plans.length,
                            itemBuilder: (context, index) => PlanWidget(plan: provider.plans[index], isSelected: provider.selectedPlan == provider.plans[index]),
                          ),
                        ),
                        CButton(
                          isLoading: provider.isSubscribing,
                          onTap: () => provider.subscribe(context, ref),
                          margin: EdgeInsets.only(top: 16, bottom: 48),
                          title: LocaleKeys.subscribe.tr(),
                          titleWithIcon: true,
                        ),
                      ],
                    ),
                  ),
                  SlidingUpPanelWidget(controlHeight: 0, anchor: 0.15, panelController: provider.panelController, child: PaymentSheet()),
                ],
              ),
    );
  }
}

class PlanWidget extends ConsumerWidget {
  const PlanWidget({super.key, required this.plan, required this.isSelected});
  final PlanModel plan;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicCard(
      onTap: () => ref.read(subscriptionProvider.notifier).selectPlan(plan),
      borderColor: isSelected ? CColors.primary : CColors.greyShade1,
      boxShadow: isSelected ? null : [],
      margin: EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [if (plan.duration.isInfinite) Text(LocaleKeys.unlimited.tr()) else Text('${plan.duration} ${LocaleKeys.months.tr()}'), Text('\$${plan.amount} ${LocaleKeys.price.tr()}')],
      ),
    );
  }
}

class PaymentSheet extends ConsumerWidget {
  const PaymentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(subscriptionProvider);
    return Container(
      decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30)))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            GooglePayButton(
              onPaymentResult: (result) => ref.read(subscriptionProvider.notifier).onPaymentResult(result, context, ref),
              paymentItems: [PaymentItem(amount: provider.selectedPlan!.amount.toString(), label: '${provider.selectedPlan!.duration} ${LocaleKeys.months.tr()}')],
              totalPrice: provider.selectedPlan!.amount.toString(),
              merchantId: '',
              merchantName: '',
            ),
          ],
        ),
      ),
    );
  }
}
