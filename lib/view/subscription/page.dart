import '../../export.dart';

class SubscriptionPlansPage extends ConsumerStatefulWidget {
  const SubscriptionPlansPage({super.key, this.isRenewingPlan = false});
  final bool isRenewingPlan;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends ConsumerState<SubscriptionPlansPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ref.read(subscriptionProvider).context = context;
    ref.read(subscriptionProvider).ref = ref;
    ref.read(subscriptionProvider).isRenewingPlan = widget.isRenewingPlan;
    ref.read(subscriptionProvider.notifier).getSubscriptionPlans();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(subscriptionProvider);
    return IgnorePointer(
      ignoring: provider.isSubscribing,
      child: Background(
        backgroundType: BackgroundType.logo,
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('3 ${LocaleKeys.months.tr()}', style: CTextStyle.w500(fontSize: 18, color: Colors.black)),
            Padding(
              padding: context.edgeInsets(horizontal: 8),
              child: SizedBox(
                height: context.h(25),
                child: FittedBox(
                  child: Switch(
                    value: !provider.showThreeMonthPlans,
                    thumbColor: WidgetStatePropertyAll(CColors.deepTeal),
                    overlayColor: WidgetStatePropertyAll(CColors.deepTeal),
                    activeThumbColor: CColors.deepTeal,
                    trackColor: WidgetStatePropertyAll(CColors.primary.withValues(alpha: 0.1)),
                    onChanged: provider.togglePlans,
                  ),
                ),
              ),
            ),
            Text('1 ${LocaleKeys.year.tr()}', style: CTextStyle.w500(fontSize: 18, color: Colors.black)),
          ],
        ),
        titleType: provider.isRenewingPlan ? TitleType.backArrow : TitleType.empty,
        titleMargin: context.edgeInsets(horizontal: 20, vertical: 25),
        margin: context.edgeInsets(top: kToolbarHeight / 2),
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
                            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                            child: Column(
                              children: [
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
                                if (!provider.isRenewingPlan)
                                  BasicCard(onTap: provider.enterKeyDialog, backgroundColor: CColors.duaBackground, child: Text(LocaleKeys.enter_access_key_prompt.tr(), style: CTextStyle.w500(color: CColors.primary, fontSize: 14))),
                              ],
                            ),
                          ),
                        ),
                        SlidingUpPanelWidget(controlHeight: 0, anchor: 0.4, panelController: provider.panelController, child: PaymentSheet()),
                      ],
                    );
                  },
                ),
      ),
    );
  }
}
