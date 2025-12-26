import '../export.dart';

class PlanWidget extends ConsumerWidget {
  const PlanWidget({super.key, required this.plan, required this.isSelected, required this.onSubscribe});
  final PlanModel plan;
  final bool isSelected;
  final VoidCallback? onSubscribe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isSelected) {
      return BasicCard(
        onTap: () => ref.read(subscriptionProvider.notifier).selectPlan(plan),
        borderColor: CColors.grey,
        backgroundGradient: CColors.planCardBackgroundGradient,
        margin: ScaledEdgeInsets.only(bottom: 32, left: 16, right: 16),
        padding: ScaledEdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isLTR(context) ? plan.name_en : plan.name_ur, style: CTextStyle.w500(color: CColors.darkIndigo, fontSize: 20)),
                  Padding(
                    padding: ScaledEdgeInsets.only(top: 32),
                    child: switch (plan.has_discount) {
                      true => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$currencySymbol ${plan.discount_amount}', style: CTextStyle.w400(color: CColors.darkIndigo, fontSize: 20)),
                          Text('$currencySymbol ${plan.amount}', style: CTextStyle.w400(color: CColors.greyShade1, fontSize: 14, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      _ => Text('$currencySymbol ${plan.amount}', style: CTextStyle.w400(color: CColors.darkIndigo, fontSize: 20)),
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Transform.rotate(angle: pi / 2, child: CustomImage(path: 'assets/svg/go_forward.svg', imageType: ImageType.svg, color: CColors.deepTeal, size: 20.pr)),
                  CButton(
                    isLoading: ref.watch(subscriptionProvider).isSubscribing,
                    onTap: onSubscribe,
                    margin: ScaledEdgeInsets.only(top: 24),
                    titleWithIcon: true,
                    padding: isLTR(context) ? null : ScaledEdgeInsets.only(right: 16),
                    title: LocaleKeys.buy.tr(),
                    iconSize: 20,
                    useTitleWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return BasicCard(
        onTap: () => ref.read(subscriptionProvider.notifier).selectPlan(plan),
        borderColor: CColors.grey,
        backgroundGradient: CColors.planCardBackgroundGradient,
        margin: ScaledEdgeInsets.only(bottom: 32, left: 16, right: 16),
        padding: ScaledEdgeInsets.all(16),
        child: Row(
          children: [
            Text(isLTR(context) ? plan.name_en : plan.name_ur, style: CTextStyle.w400(color: CColors.darkIndigo, fontSize: 18)),
            Expanded(
              child: Padding(
                padding: ScaledEdgeInsets.only(left: 16),
                child: ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (rect) => CColors.planTextGradient.createShader(rect), child: Text(plan.member_count_label, style: CTextStyle.w900(color: Colors.white, fontSize: 16))),
              ),
            ),
            CustomImage(path: 'assets/svg/go_forward.svg', imageType: ImageType.svg, color: CColors.deepTeal, size: 18),
          ],
        ),
      );
    }
  }
}
