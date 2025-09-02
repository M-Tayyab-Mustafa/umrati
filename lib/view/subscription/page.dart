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
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(subscriptionProvider);
    ref.read(subscriptionProvider).context = context;
    ref.read(subscriptionProvider).ref = ref;
    return Background(
      backgroundType: BackgroundType.logo,
      margin: EdgeInsets.only(top: kToolbarHeight / 2),
      logoAlign: Alignment.topCenter,
      child:
          provider.isLoading
              ? Loading()
              : Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight / 2),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: Padding(
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
                                  onTap: provider.subscribe,
                                  margin: EdgeInsets.only(top: 16, bottom: 48),
                                  title: LocaleKeys.subscribe.tr(),
                                  titleWithIcon: true,
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
              ),
    );
  }
}
