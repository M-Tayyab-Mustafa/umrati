import '../export.dart';

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
        children: [if (plan.duration.isNegative) Text(LocaleKeys.unlimited.tr()) else Text('${plan.duration} ${LocaleKeys.months.tr()}'), Text('\$${plan.amount} ${LocaleKeys.price.tr()}')],
      ),
    );
  }
}
