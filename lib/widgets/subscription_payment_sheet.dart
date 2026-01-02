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
          padding: ScaledEdgeInsets.all(16),
          child: Column(
            children: [
              Padding(padding: ScaledEdgeInsets.only(bottom: 16), child: Center(child: Container(width: 40.pr, height: 5.pr, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))))),
              Padding(padding: ScaledEdgeInsets.only(bottom: 32), child: Text(LocaleKeys.choose_payment_method.tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade800))),
              if (Payment.instance.paymentSetting!.showApplePayButton)
                ApplePayButton(
                  margin: EdgeInsets.zero,
                  merchantId: Payment.instance.paymentSetting!.appleMerchantId,
                  merchantName: Payment.instance.paymentSetting!.appleMerchantName,
                  width: SizeConfig.mediaQuery.size.width,
                  amount: provider.selectedPlan.amount.toString(),
                  paymentItems: [
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}'),
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}', status: PaymentItemStatus.final_price, type: PaymentItemType.total),
                  ],
                  onPaymentResult: ref.read(subscriptionProvider.notifier).onPaymentResult,
                ),
              if (Payment.instance.paymentSetting!.showGooglePayButton)
                GooglePayButton(
                  margin: ScaledEdgeInsets.only(top: 16),
                  merchantId: Payment.instance.paymentSetting!.googleMerchantId,
                  merchantName: Payment.instance.paymentSetting!.googleMerchantName,
                  width: SizeConfig.mediaQuery.size.width,
                  totalPrice: provider.selectedPlan.amount.toString(),
                  paymentItems: [
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}'),
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}', status: PaymentItemStatus.final_price, type: PaymentItemType.total),
                  ],
                  onPaymentResult: ref.read(subscriptionProvider.notifier).onPaymentResult,
                ),
              if (provider.userRegion == 'PK' && Payment.instance.paymentSetting!.showJazzCashButton)
                PaymentButton(
                  iconPadding: ScaledEdgeInsets.all(4),
                  iconPath: 'assets/png/jazz_cash.png',
                  iconType: ImageType.png,
                  iconBackgroundColor: Colors.white,
                  isLoading: provider.isLoadingJazzCashPaymentMethod,
                  margin: ScaledEdgeInsets.only(top: 16),
                  onTap: ref.read(subscriptionProvider.notifier).onJazzCashTap,
                  title: 'Pay with Jazz Cash',
                ),
              if (provider.userRegion == 'PK' && Payment.instance.paymentSetting!.showEasyPaisaButton)
                PaymentButton(
                  iconPadding: ScaledEdgeInsets.all(4),
                  iconPath: 'assets/png/easy_paisa.png',
                  iconType: ImageType.png,
                  iconBackgroundColor: Colors.white,
                  isLoading: provider.isLoadingEasyPaisaPaymentMethod,
                  margin: ScaledEdgeInsets.only(top: 16),
                  onTap: ref.read(subscriptionProvider.notifier).onEasyPaisaTap,
                  title: 'Pay with Easy Paisa',
                ),
              if (Payment.instance.paymentSetting!.showStripeButton)
                PaymentButton(
                  icon: FaIcon(FontAwesomeIcons.stripe, color: Colors.white),
                  isLoading: provider.isLoadingStripePaymentMethod,
                  margin: ScaledEdgeInsets.only(top: 16),
                  onTap: ref.read(subscriptionProvider.notifier).onCardTab,
                  title: 'Pay with Card',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
