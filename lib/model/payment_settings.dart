import '../export.dart';

class PaymentSettingsModel {
  final bool showApplePayButton;
  final String appleMerchantId;
  final String appleMerchantName;
  final bool showGooglePayButton;
  final String googleMerchantId;
  final String googleMerchantName;
  final bool showJazzCashButton;
  final String jazzCashMerchantId;
  final String jazzCashReturnUrl;
  final bool showEasyPaisaButton;
  final String easyPaisaStoreId;
  final String easyPaisaReturnUrl;
  final bool showStripeButton;
  final String stripePublishableKey;
  final String stripeSecretKey;
  PaymentSettingsModel({
    required this.showApplePayButton,
    required this.appleMerchantId,
    required this.appleMerchantName,
    required this.showGooglePayButton,
    required this.googleMerchantId,
    required this.googleMerchantName,
    required this.showJazzCashButton,
    required this.jazzCashMerchantId,
    required this.jazzCashReturnUrl,
    required this.showEasyPaisaButton,
    required this.easyPaisaStoreId,
    required this.easyPaisaReturnUrl,
    required this.showStripeButton,
    required this.stripePublishableKey,
    required this.stripeSecretKey,
  });

  PaymentSettingsModel copyWith({
    bool? showApplePayButton,
    String? appleMerchantId,
    String? appleMerchantName,
    bool? showGooglePayButton,
    String? googleMerchantId,
    String? googleMerchantName,
    bool? showJazzCashButton,
    String? jazzCashMerchantId,
    String? jazzCashReturnUrl,
    bool? showEasyPaisaButton,
    String? easyPaisaStoreId,
    String? easyPaisaReturnUrl,
    bool? showStripeButton,
    String? stripePublishableKey,
    String? stripeSecretKey,
  }) {
    return PaymentSettingsModel(
      showApplePayButton: showApplePayButton ?? this.showApplePayButton,
      appleMerchantId: appleMerchantId ?? this.appleMerchantId,
      appleMerchantName: appleMerchantName ?? this.appleMerchantName,
      showGooglePayButton: showGooglePayButton ?? this.showGooglePayButton,
      googleMerchantId: googleMerchantId ?? this.googleMerchantId,
      googleMerchantName: googleMerchantName ?? this.googleMerchantName,
      showJazzCashButton: showJazzCashButton ?? this.showJazzCashButton,
      jazzCashMerchantId: jazzCashMerchantId ?? this.jazzCashMerchantId,
      jazzCashReturnUrl: jazzCashReturnUrl ?? this.jazzCashReturnUrl,
      showEasyPaisaButton: showEasyPaisaButton ?? this.showEasyPaisaButton,
      easyPaisaStoreId: easyPaisaStoreId ?? this.easyPaisaStoreId,
      easyPaisaReturnUrl: easyPaisaReturnUrl ?? this.easyPaisaReturnUrl,
      showStripeButton: showStripeButton ?? this.showStripeButton,
      stripePublishableKey: stripePublishableKey ?? this.stripePublishableKey,
      stripeSecretKey: stripeSecretKey ?? this.stripeSecretKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'showApplePayButton': showApplePayButton,
      'appleMerchantId': appleMerchantId,
      'appleMerchantName': appleMerchantName,
      'showGooglePayButton': showGooglePayButton,
      'googleMerchantId': googleMerchantId,
      'googleMerchantName': googleMerchantName,
      'showJazzCashButton': showJazzCashButton,
      'jazzCashMerchantId': jazzCashMerchantId,
      'jazzCashReturnUrl': jazzCashReturnUrl,
      'showEasyPaisaButton': showEasyPaisaButton,
      'easyPaisaStoreId': easyPaisaStoreId,
      'easyPaisaReturnUrl': easyPaisaReturnUrl,
      'showStripeButton': showStripeButton,
      'stripePublishableKey': stripePublishableKey,
      'stripeSecretKey': stripeSecretKey,
    };
  }

  factory PaymentSettingsModel.fromMap(Map<String, dynamic> map) {
    return PaymentSettingsModel(
      showApplePayButton: map['showApplePayButton'] ?? false,
      appleMerchantId: map['appleMerchantId']?.toString() ?? '',
      appleMerchantName: map['appleMerchantName']?.toString() ?? '',
      showGooglePayButton: map['showGooglePayButton'] ?? false,
      googleMerchantId: map['googleMerchantId']?.toString() ?? '',
      googleMerchantName: map['googleMerchantName']?.toString() ?? '',
      showJazzCashButton: map['showJazzCashButton'] ?? false,
      jazzCashMerchantId: map['jazzCashMerchantId']?.toString() ?? '',
      jazzCashReturnUrl: map['jazzCashReturnUrl']?.toString() ?? '',
      showEasyPaisaButton: map['showEasyPaisaButton'] ?? false,
      easyPaisaStoreId: map['easyPaisaStoreId']?.toString() ?? '',
      easyPaisaReturnUrl: map['easyPaisaReturnUrl']?.toString() ?? '',
      showStripeButton: map['showStripeButton'] ?? false,
      stripePublishableKey: map['stripePublishableKey']?.toString() ?? '',
      stripeSecretKey: map['stripeSecretKey']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentSettingsModel.fromJson(String source) => PaymentSettingsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentSettingsModel(showApplePayButton: $showApplePayButton, appleMerchantId: $appleMerchantId, appleMerchantName: $appleMerchantName, showGooglePayButton: $showGooglePayButton, googleMerchantId: $googleMerchantId, googleMerchantName: $googleMerchantName, showJazzCashButton: $showJazzCashButton, jazzCashMerchantId: $jazzCashMerchantId, jazzCashReturnUrl: $jazzCashReturnUrl, showEasyPaisaButton: $showEasyPaisaButton, easyPaisaStoreId: $easyPaisaStoreId, easyPaisaReturnUrl: $easyPaisaReturnUrl, showStripeButton: $showStripeButton, stripePublishableKey: $stripePublishableKey, stripeSecretKey: $stripeSecretKey)';
  }

  @override
  bool operator ==(covariant PaymentSettingsModel other) {
    if (identical(this, other)) return true;

    return other.showApplePayButton == showApplePayButton &&
        other.appleMerchantId == appleMerchantId &&
        other.appleMerchantName == appleMerchantName &&
        other.showGooglePayButton == showGooglePayButton &&
        other.googleMerchantId == googleMerchantId &&
        other.googleMerchantName == googleMerchantName &&
        other.showJazzCashButton == showJazzCashButton &&
        other.jazzCashMerchantId == jazzCashMerchantId &&
        other.jazzCashReturnUrl == jazzCashReturnUrl &&
        other.showEasyPaisaButton == showEasyPaisaButton &&
        other.easyPaisaStoreId == easyPaisaStoreId &&
        other.easyPaisaReturnUrl == easyPaisaReturnUrl &&
        other.showStripeButton == showStripeButton &&
        other.stripePublishableKey == stripePublishableKey &&
        other.stripeSecretKey == stripeSecretKey;
  }

  @override
  int get hashCode {
    return showApplePayButton.hashCode ^
        appleMerchantId.hashCode ^
        appleMerchantName.hashCode ^
        showGooglePayButton.hashCode ^
        googleMerchantId.hashCode ^
        googleMerchantName.hashCode ^
        showJazzCashButton.hashCode ^
        jazzCashMerchantId.hashCode ^
        jazzCashReturnUrl.hashCode ^
        showEasyPaisaButton.hashCode ^
        easyPaisaStoreId.hashCode ^
        easyPaisaReturnUrl.hashCode ^
        showStripeButton.hashCode ^
        stripePublishableKey.hashCode ^
        stripeSecretKey.hashCode;
  }
}
