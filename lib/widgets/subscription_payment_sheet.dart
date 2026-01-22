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
          padding: context.edgeInsets(all: 16),
          child: Column(
            children: [
              Padding(padding: context.edgeInsets(bottom: 16), child: Center(child: Container(width: context.w(40), height: context.h(5), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))))),
              Padding(padding: context.edgeInsets(bottom: 32), child: Text(LocaleKeys.choose_payment_method.tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade800))),
              if (Payment.instance.paymentSetting!.showApplePayButton && Platform.isIOS)
                ApplePayButton(
                  margin: EdgeInsets.zero,
                  merchantId: Payment.instance.paymentSetting!.appleMerchantId,
                  merchantName: Payment.instance.paymentSetting!.appleMerchantName,
                  width: MediaQuery.sizeOf(context).width,
                  amount: provider.selectedPlan.amount.toString(),
                  paymentItems: [
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}'),
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}', status: PaymentItemStatus.final_price, type: PaymentItemType.total),
                  ],
                  onPaymentResult: (result) => ref.read(subscriptionProvider.notifier).onPaymentResult(result, context),
                ),
              if (Payment.instance.paymentSetting!.showGooglePayButton)
                GooglePayButton(
                  margin: context.edgeInsets(top: 16),
                  publicKey: Payment.instance.paymentSetting!.googlePublicKey,
                  merchantId: Payment.instance.paymentSetting!.googleMerchantId,
                  merchantName: Payment.instance.paymentSetting!.googleMerchantName,
                  width: MediaQuery.sizeOf(context).width,
                  totalPrice: provider.selectedPlan.amount.toString(),
                  paymentItems: [
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}'),
                    PaymentItem(amount: provider.selectedPlan.amount.toString(), label: '${(provider.selectedPlan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}', status: PaymentItemStatus.final_price, type: PaymentItemType.total),
                  ],
                  onPaymentResult: (result) => ref.read(subscriptionProvider.notifier).onPaymentResult(result, context),
                ),
              if (provider.userRegion == 'PK' && Payment.instance.paymentSetting!.showJazzCashButton)
                PaymentButton(
                  iconPadding: context.edgeInsets(all: 4),
                  iconPath: 'assets/png/jazz_cash.png',
                  iconType: ImageType.png,
                  iconBackgroundColor: Colors.white,
                  isLoading: provider.isLoadingJazzCashPaymentMethod,
                  margin: context.edgeInsets(top: 16),
                  onTap: () => ref.read(subscriptionProvider.notifier).onJazzCashTap(context),
                  title: 'Pay with Jazz Cash',
                ),
              if (provider.userRegion == 'PK' && Payment.instance.paymentSetting!.showEasyPaisaButton)
                PaymentButton(
                  iconPadding: context.edgeInsets(all: 4),
                  iconPath: 'assets/png/easy_paisa.png',
                  iconType: ImageType.png,
                  iconBackgroundColor: Colors.white,
                  isLoading: provider.isLoadingEasyPaisaPaymentMethod,
                  margin: context.edgeInsets(top: 16),
                  onTap: () => ref.read(subscriptionProvider.notifier).onEasyPaisaTap(context),
                  title: 'Pay with Easy Paisa',
                ),
              if (Payment.instance.paymentSetting!.showStripeButton)
                PaymentButton(
                  icon: FaIcon(FontAwesomeIcons.stripe, color: Colors.white),
                  isLoading: provider.isLoadingStripePaymentMethod,
                  margin: context.edgeInsets(top: 16),
                  onTap: () => ref.read(subscriptionProvider.notifier).onCardTab(context),
                  title: 'Pay with Card',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
