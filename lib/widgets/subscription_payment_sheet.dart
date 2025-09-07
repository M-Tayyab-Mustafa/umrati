import '../export.dart';

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
              onPaymentResult: ref.read(subscriptionProvider.notifier).onPaymentResult,
              paymentItems: [PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}')],
              totalPrice: provider.selectedPlan.amount.toString(),
              merchantId: '',
              merchantName: '',
            ),
          ],
        ),
      ),
    );
  }
}
