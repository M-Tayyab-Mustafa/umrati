import '../export.dart';

class PaymentSheet extends ConsumerWidget {
  const PaymentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(subscriptionProvider);
    final plan = provider.selectedPlan;
    final settings = Payment.instance.paymentSetting!;
    final monthsLabel = '${(plan.duration / 30).toInt().clamp(1, 12)} ${LocaleKeys.months.tr()}';

    final paymentItems = [PaymentItem(amount: plan.amount.toString(), label: monthsLabel), PaymentItem(amount: plan.amount.toString(), label: monthsLabel, status: PaymentItemStatus.final_price, type: PaymentItemType.total)];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: const BorderRadius.vertical(top: Radius.circular(30)))),
        child: Padding(
          padding: context.edgeInsets(all: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: context.edgeInsets(bottom: 16), child: Center(child: Container(width: context.w(40), height: context.h(5), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))))),
              Padding(padding: context.edgeInsets(bottom: 32), child: Text(LocaleKeys.choose_payment_method.tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade800))),
              if (settings.showApplePayButton && Platform.isIOS)
                ApplePayButton(
                  margin: EdgeInsets.zero,
                  merchantId: settings.appleMerchantId,
                  merchantName: settings.appleMerchantName,
                  width: MediaQuery.sizeOf(context).width,
                  amount: plan.amount.toString(),
                  paymentItems: paymentItems,
                  onPaymentResult: (result) => ref.read(subscriptionProvider.notifier).onPaymentResult(result, context),
                ),
              if (settings.showGooglePayButton)
                GooglePayButton(
                  margin: context.edgeInsets(top: 16),
                  publicKey: settings.googlePublicKey,
                  merchantId: settings.googleMerchantId,
                  merchantName: settings.googleMerchantName,
                  width: MediaQuery.sizeOf(context).width,
                  totalPrice: plan.amount.toString(),
                  paymentItems: paymentItems,
                  onPaymentResult: (result) => ref.read(subscriptionProvider.notifier).onPaymentResult(result, context),
                ),
              if (provider.userRegion == 'PK' && settings.showJazzCashButton)
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
              if (provider.userRegion == 'PK' && settings.showEasyPaisaButton)
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
              if (settings.showStripeButton)
                PaymentButton(
                  icon: const FaIcon(FontAwesomeIcons.stripe, color: Colors.white),
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
