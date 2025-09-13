import '../../export.dart';

class SubscriptionPlansPage extends ConsumerStatefulWidget {
  const SubscriptionPlansPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends ConsumerState<SubscriptionPlansPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ref.read(subscriptionProvider.notifier).getSubscriptionPlans();
    ref.read(subscriptionProvider).context = context;
    ref.read(subscriptionProvider).ref = ref;
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
              : LayoutBuilder(
                builder: (context, constraints) {
                  var plans = <PlanModel>[];
                  if (provider.showThreeMonthPlans) {
                    plans = provider.plans.where((element) => element.duration == 90).toList();
                  } else {
                    plans = provider.plans.where((element) => element.duration != 90).toList();
                  }
                  return Stack(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('3 ${LocaleKeys.months.tr()}', style: CTextStyle.w500(fontSize: 16, color: Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: SizedBox(
                                        height: 30,
                                        child: FittedBox(
                                          child: Switch(
                                            value: provider.showThreeMonthPlans,
                                            thumbColor: WidgetStatePropertyAll(CColors.deepTeal),
                                            overlayColor: WidgetStatePropertyAll(CColors.deepTeal),
                                            activeColor: CColors.deepTeal,
                                            trackColor: WidgetStatePropertyAll(CColors.primary.withValues(alpha: 0.1)),
                                            onChanged: provider.togglePlans,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('1 ${LocaleKeys.year.tr()}', style: CTextStyle.w500(fontSize: 16, color: Colors.black)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: plans.length,
                                  itemBuilder: (context, index) {
                                    return PlanWidget(onSubscribe: provider.subscribe, plan: plans[index], isSelected: provider.selectedPlan == plans[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SlidingUpPanelWidget(controlHeight: 0, anchor: 0.15, panelController: provider.panelController, child: PaymentSheet()),
                    ],
                  );
                },
              ),
    );
  }
}
