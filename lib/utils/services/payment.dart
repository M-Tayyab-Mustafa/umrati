import '../../export.dart';

class Payment {
  Payment._internal();
  static Payment? _instance;
  static Payment get instance => _instance ??= Payment._internal();
  PaymentSettingsModel? paymentSetting;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? paymentSettingSubscription;

  Future<void> initializePayments() async {
    try {
      paymentSettingSubscription?.cancel();
      paymentSettingSubscription = settingsCollection.doc(CommonDoc.paymentSettings.name).snapshots().listen((event) {
        paymentSetting = PaymentSettingsModel.fromMap(event.data()!);
        Stripe.publishableKey = paymentSetting?.stripePublishableKey ?? '';
      });
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }

  Future<void> makeStripePayment({required String userRegion, required String amount, required void Function() onSuccess}) async {
    try {
      var currencyCode = (await settingsCollection.doc(CommonDoc.constants.name).get()).get(CommonField.currencyCode.name)[userRegion].toString();
      final response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer ${paymentSetting!.stripeSecretKey}', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'amount': (num.parse(amount) * 100).toString(), 'currency': currencyCode.toLowerCase(), 'payment_method_types[]': 'card'},
      );
      final paymentIntent = jsonDecode(response.body);
      if (response.statusCode != 200) {
        if (kDebugMode) log(paymentIntent.toString());
        errorToast(paymentIntent['error']['message']);
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(paymentIntentClientSecret: paymentIntent!['client_secret'], merchantDisplayName: 'Test Shop', allowsDelayedPaymentMethods: false, appearance: PaymentSheetAppearance()),
      );
      await Stripe.instance.presentPaymentSheet();
      onSuccess();
    } on StripeException catch (e) {
      appLog(e.toString());
      errorToast("⚠️ Payment Error: ${e.error.message}");
    } catch (e) {
      appLog(e.toString());
      errorToast("⚠️ Payment Error: $e");
    }
  }

  Future<void> makePaymentByJazzCash({required BuildContext context, required String userRegion, required String amount, required void Function() onSuccess}) async {
    try {
      final String paymentUrl =
          "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/?"
          "pp_Version=1.1"
          "&pp_TxnType=MWALLET"
          "&pp_MerchantID=${paymentSetting?.jazzCashMerchantId}"
          "&pp_Amount=$amount"
          "&pp_TxnRefNo=${DateTime.now().millisecondsSinceEpoch.toString()}"
          "&pp_ReturnURL=${paymentSetting?.jazzCashReturnUrl}"
          "&pp_Description=TestPayment"
          "&pp_Language=EN";
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CommonPaymentWebView(paymentUrl: paymentUrl, isSuccess: (url) => url.contains("pp_ResponseCode=000"), isFailure: (url) => url.contains("pp_ResponseCode") && !url.contains("pp_ResponseCode=000"))),
      );
      if (result == true) {
        onSuccess();
      } else if (result == false) {
        errorToast("⚠️ Payment Failed");
      } else {
        errorToast("Payment cancelled");
      }
    } catch (e) {
      appLog(e.toString());
      errorToast("⚠️ Payment Error: $e");
    }
  }

  Future<void> makePaymentByEasyPaisa({required BuildContext context, required String userRegion, required String amount, required void Function() onSuccess}) async {
    try {
      final String paymentUrl =
          "https://easypaystg.easypaisa.com.pk/easypay/Index.jsf?"
          "storeId=${paymentSetting?.easyPaisaStoreId}"
          "&amount=$amount"
          "&postBackURL=${paymentSetting?.easyPaisaReturnUrl}"
          "&orderRefNum=${DateTime.now().millisecondsSinceEpoch.toString()}"
          "&expiryDate=2025-12-31%2023:59:59"
          "&autoRedirect=1";
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CommonPaymentWebView(paymentUrl: paymentUrl, isSuccess: (url) => url.contains("responseCode=000"), isFailure: (url) => url.contains("responseCode") && !url.contains("responseCode=000"))),
      );

      if (result == true) {
        onSuccess();
      } else if (result == false) {
        errorToast("⚠️ Payment Failed");
      } else {
        errorToast("Payment cancelled");
      }
    } catch (e) {
      appLog(e.toString());
      errorToast("⚠️ Payment Error: $e");
    }
  }
}

class CommonPaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final bool Function(String url) isSuccess;
  final bool Function(String url) isFailure;

  const CommonPaymentWebView({required this.paymentUrl, required this.isSuccess, required this.isFailure, super.key});

  @override
  State<CommonPaymentWebView> createState() => _CommonPaymentWebViewState();
}

class _CommonPaymentWebViewState extends State<CommonPaymentWebView> {
  late final WebViewController _controller;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                final url = request.url;

                if (_isCompleted) {
                  return NavigationDecision.prevent;
                }

                if (widget.isSuccess(url)) {
                  _isCompleted = true;
                  Navigator.pop(context, true);
                  return NavigationDecision.prevent;
                }

                if (widget.isFailure(url)) {
                  _isCompleted = true;
                  Navigator.pop(context, false);
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
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
