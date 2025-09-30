import '../../export.dart';

class Payment {
  Payment._internal();
  static Payment? _instance;
  static Payment get instance => _instance ??= Payment._internal();
  DocumentSnapshot<Map<String, dynamic>>? keysDoc;

  Future<void> initializePayments() async {
    try {
      keysDoc = await settingsCollection.doc(CommonDoc.keys.name).get();
      Stripe.publishableKey = keysDoc?.get(CommonField.stripePublishableKey.name) ?? '';
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  Future<void> makeStripePayment({required String userRegion, required String amount, required void Function() onSuccess}) async {
    try {
      var currencyCode = (await settingsCollection.doc(CommonDoc.constants.name).get()).get(CommonField.currencyCode.name)[userRegion].toString();
      final response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer ${keysDoc?.get(CommonField.stripeSecretKey.name)}', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'amount': (num.parse(amount) * 100).toString(), 'currency': currencyCode.toLowerCase(), 'payment_method_types[]': 'card'},
      );
      final paymentIntent = jsonDecode(response.body);
      if (response.statusCode != 200) {
        if (kDebugMode) log(paymentIntent.toString());
        errorToast(paymentIntent['error']['message']);
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Test Shop',
          allowsDelayedPaymentMethods: false,
          appearance: PaymentSheetAppearance(),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      onSuccess();
    } on StripeException catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast("⚠️ Payment Error: ${e.error.message}");
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast("⚠️ Payment Error: $e");
    }
  }

  Future<void> makePaymentByJazzCash({required BuildContext context, required String userRegion, required String amount, required void Function() onSuccess}) async {
    try {
      final String merchantId = "MC12345";
      final String returnUrl = "https://sandbox.jazzcash.com.pk/ReturnUrl";
      final String transactionRef = DateTime.now().millisecondsSinceEpoch.toString();
      final String paymentUrl =
          "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/?"
          "pp_Version=1.1"
          "&pp_TxnType=MWALLET"
          "&pp_MerchantID=$merchantId"
          "&pp_Amount=$amount"
          "&pp_TxnRefNo=$transactionRef"
          "&pp_ReturnURL=$returnUrl"
          "&pp_Description=TestPayment"
          "&pp_Language=EN";
      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => _PaymentWebView(paymentUrl: paymentUrl)));
      if (result == true) onSuccess();
      errorToast("⚠️ Payment Failed");
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast("⚠️ Payment Error: $e");
    }
  }

  Future<void> makePaymentByEasyPaisa({required BuildContext context, required String userRegion, required String amount, required void Function() onSuccess}) async {
    try {
      final String storeId = "12345";
      final String orderRefNum = DateTime.now().millisecondsSinceEpoch.toString();
      final String paymentUrl =
          "https://easypaystg.easypaisa.com.pk/easypay/Index.jsf?"
          "storeId=$storeId"
          "&amount=$amount"
          "&postBackURL=https://yourdomain.com/callback"
          "&orderRefNum=$orderRefNum"
          "&expiryDate=2025-12-31%2023:59:59"
          "&autoRedirect=1";
      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => _PaymentWebView(paymentUrl: paymentUrl)));
      if (result == true) onSuccess();
      errorToast("⚠️ Payment Failed");
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast("⚠️ Payment Error: $e");
    }
  }
}

class _PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  const _PaymentWebView({required this.paymentUrl});

  @override
  State<_PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<_PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (url) {
                if (url.contains("SUCCESS") || url.contains("000")) {
                  Navigator.pop(context, true);
                } else if (url.contains("FAILED")) {
                  Navigator.pop(context, false);
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Background(showEmblem: false, margin: EdgeInsets.zero, title: '', backgroundType: BackgroundType.titleWithBackButton, child: WebViewWidget(controller: _controller));
  }
}
