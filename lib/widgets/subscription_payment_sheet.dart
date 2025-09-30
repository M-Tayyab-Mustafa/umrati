import '../export.dart';

class PaymentSheet extends ConsumerWidget {
  const PaymentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(subscriptionProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30)))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              ApplePayButton(
                margin: EdgeInsets.zero,
                merchantId: '',
                merchantName: '',
                amount: provider.selectedPlan.amount.toString(),
                paymentItems: [PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}')],
                onPaymentResult: ref.read(subscriptionProvider.notifier).onPaymentResult,
              ),
              GooglePayButton(
                margin: EdgeInsets.symmetric(vertical: 16),
                onPaymentResult: ref.read(subscriptionProvider.notifier).onPaymentResult,
                paymentItems: [PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}')],
                totalPrice: provider.selectedPlan.amount.toString(),
                merchantId: '',
                merchantName: '',
              ),
              PaymentButton(isLoading: provider.isLoadingJazzCashPaymentMethod, margin: EdgeInsets.zero, onTap: ref.read(subscriptionProvider.notifier).onJazzCashTap, title: 'Jazz Cash'),
              PaymentButton(
                isLoading: provider.isLoadingEasyPaisaPaymentMethod,
                margin: EdgeInsets.symmetric(vertical: 16),
                onTap: ref.read(subscriptionProvider.notifier).onEasyPaisaTap,
                title: 'Easy Paisa',
              ),
              PaymentButton(isLoading: provider.isLoadingStripePaymentMethod, margin: EdgeInsets.zero, onTap: ref.read(subscriptionProvider.notifier).onCardTab, title: 'Credit Card Payment'),
            ],
          ),
        ),
      ),
    );
  }
}
