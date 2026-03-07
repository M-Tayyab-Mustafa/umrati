import '../export.dart';

class PlanWidget extends ConsumerWidget {
  const PlanWidget({super.key, required this.plan, required this.isSelected, required this.onSubscribe});

  final PlanModel plan;
  final bool isSelected;
  final VoidCallback? onSubscribe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isSelected ? _SelectedPlanCard(plan: plan, onSubscribe: onSubscribe) : _UnselectedPlanCard(plan: plan);
  }
}

class _SelectedPlanCard extends ConsumerWidget {
  const _SelectedPlanCard({required this.plan, this.onSubscribe});
  final PlanModel plan;
  final VoidCallback? onSubscribe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(subscriptionProvider).isSubscribing;
    return BasicCard(
      onTap: () => ref.read(subscriptionProvider.notifier).selectPlan(plan),
      borderColor: CColors.grey,
      backgroundGradient: CColors.planCardBackgroundGradient,
      margin: context.edgeInsets(bottom: 32, left: 16, right: 16),
      padding: context.edgeInsets(horizontal: 20, bottom: 24, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(isLTR(context) ? plan.name_en : plan.name_ur, style: CTextStyle.w500(color: CColors.darkIndigo, fontSize: 20)),
              if (plan.discount > 0) _DiscountBadge(discount: plan.discount) else Container(margin: context.edgeInsets(left: isLTR(context) ? 16 : 0, right: isLTR(context) ? 0 : 16), width: 45.w, height: 45.w, padding: context.edgeInsets(all: 10)),
              const Spacer(),
              Transform.rotate(angle: pi / 2, child: CustomImage(path: 'assets/svg/go_forward.svg', imageType: ImageType.svg, color: CColors.deepTeal, size: context.r(20))),
            ],
          ),
          Padding(
            padding: context.edgeInsets(top: 16),
            child: Row(
              children: [
                Expanded(child: _PriceDisplay(plan: plan)),
                CButton(
                  height: 30.h,
                  width: 91.w,
                  isLoading: isLoading,
                  onTap: onSubscribe,
                  margin: context.edgeInsets(left: isLTR(context) ? 16 : 0, right: isLTR(context) ? 0 : 16),
                  titleWithIcon: true,
                  padding: isLTR(context) ? null : context.edgeInsets(right: 16),
                  title: LocaleKeys.buy.tr(),
                  iconSize: 18,
                  useTitleWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnselectedPlanCard extends ConsumerWidget {
  const _UnselectedPlanCard({required this.plan});
  final PlanModel plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicCard(
      onTap: () => ref.read(subscriptionProvider.notifier).selectPlan(plan),
      borderColor: CColors.grey,
      backgroundGradient: CColors.planCardBackgroundGradient,
      margin: context.edgeInsets(bottom: 32, left: 16, right: 16),
      padding: context.edgeInsets(all: 16),
      child: Row(
        children: [
          Text(isLTR(context) ? plan.name_en : plan.name_ur, style: CTextStyle.w400(color: CColors.darkIndigo, fontSize: 18)),
          Expanded(
            child: Padding(
              padding: context.edgeInsets(left: 16),
              child: ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (rect) => CColors.planTextGradient.createShader(rect), child: Text(plan.member_count_label, style: CTextStyle.w900(color: Colors.white, fontSize: 16))),
            ),
          ),
          const CustomImage(path: 'assets/svg/go_forward.svg', imageType: ImageType.svg, color: CColors.deepTeal, size: 18),
        ],
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.discount});
  final num discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.edgeInsets(left: isLTR(context) ? 16 : 0, right: isLTR(context) ? 0 : 16),
      width: 45.w,
      height: 45.w,
      padding: context.edgeInsets(all: 8),
      decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: CColors.buttonShadow, blurRadius: 5, offset: const Offset(0, 2))]),
      child: Center(
        child: FittedBox(
          child: Text.rich(TextSpan(text: 'Save', children: [TextSpan(text: '\n$discount% ', style: CTextStyle.w700(color: Colors.white, fontSize: 16))], style: CTextStyle.w500(color: Colors.white, fontSize: 11)), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class _PriceDisplay extends StatelessWidget {
  const _PriceDisplay({required this.plan});
  final PlanModel plan;

  @override
  Widget build(BuildContext context) {
    if (plan.discount > 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$currencySymbol ${Helper.getDiscountedAmount(plan.amount, plan.discount)}', style: CTextStyle.w400(color: CColors.darkIndigo, fontSize: 20)),
          Text('$currencySymbol ${plan.amount}', style: CTextStyle.w400(color: CColors.greyShade1, fontSize: 14, decoration: TextDecoration.lineThrough)),
        ],
      );
    }
    return Text('$currencySymbol ${plan.amount}', style: CTextStyle.w400(color: CColors.darkIndigo, fontSize: 20));
  }
}
