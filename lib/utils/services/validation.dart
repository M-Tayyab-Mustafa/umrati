import '../../export.dart';

String? emailValidation(String? value) {
  value = value?.trim();
  if (value == null || value.isEmpty) {
    return 'Email field can\'t be empty';
  } else if (!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))) {
    return 'Enter Correct Email';
  } else {
    return null;
  }
}

String? passwordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password field can\'t be empty';
  } else if (value.length < 8) {
    return 'Password must be more than 7 characters';
  }
  //! Enable before Build
  //  else if (!(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]$').hasMatch(value))) {
  //   return 'Please Enter Strong Password';
  // }
  else {
    return null;
  }
}

String? confirmPasswordValidation(String? value, String passwordValue) {
  if (value == null || value.isEmpty) {
    return 'Confirm Password field can\'t be empty';
  } else if (value.length < 8) {
    return 'Password must be more than 7 characters';
  } else if (value != passwordValue) {
    return 'Password not match';
  } else {
    return null;
  }
}

String? simpleFieldValidation(String? value, String fieldName, BuildContext context) {
  value = value?.trim();
  if (value == null || value.isEmpty) {
    return isLTR(context) ? '$fieldName field can\'t be empty' : '$fieldName کا خانہ خالی نہیں ہو سکتا';
  } else {
    return null;
  }
}

String? restrictedNamesValidation(String? value, String fieldName, {bool fullValidation = true}) {
  value = value?.trim();
  if ((value == null || value.isEmpty) && fullValidation) {
    return '$fieldName field can\'t be empty';
  } else if ((value?.toLowerCase().contains('admin') ?? false) ||
      (value?.toLowerCase().contains('superadmin') ?? false) ||
      (value?.toLowerCase().contains('administrator') ?? false) ||
      (value?.toLowerCase().contains('super') ?? false) ||
      (value?.toLowerCase().contains('superadministrator') ?? false)) {
    return 'This $fieldName is not allowed please use different $fieldName.';
  } else {
    return null;
  }
}

String? otpFieldValidation(String? value, int otpLength) {
  value = value?.trim();
  if (value == null || value.isEmpty) {
    return 'OTP Field can\'t be empty';
  } else if (value.length < otpLength) {
    return 'Enter valid OTP.';
  } else {
    return null;
  }
}

String? phoneValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone field can\'t be empty';
  } else if (value.length < 11) {
    return 'Please Enter Correct Number';
  } else {
    return null;
  }
}

validatePhoneNumber(String phone, String countryCode) {
  phone = phone.replaceAll(RegExp(r'[\s-]'), '');
  if (!phone.startsWith('+')) return false;
  Map<String, Map<String, dynamic>> countries = {
    'AF': {'code': '93', 'length': 12},
    'AL': {'code': '355', 'length': 12},
    'DZ': {'code': '213', 'length': 11},
    'AS': {'code': '1684', 'length': 11},
    'AD': {'code': '376', 'length': 11},
    'AO': {'code': '244', 'length': 11},
    'AI': {'code': '1264', 'length': 11},
    'AG': {'code': '1268', 'length': 11},
    'AR': {'code': '54', 'length': 12},
    'AM': {'code': '374', 'length': 11},
    'AW': {'code': '297', 'length': 11},
    'AU': {'code': '61', 'length': 12},
    'AT': {'code': '43', 'length': 11},
    'AZ': {'code': '994', 'length': 12},
    'BS': {'code': '1242', 'length': 11},
    'BH': {'code': '973', 'length': 11},
    'BD': {'code': '880', 'length': 13},
    'BB': {'code': '1246', 'length': 11},
    'BY': {'code': '375', 'length': 12},
    'BE': {'code': '32', 'length': 11},
    'BZ': {'code': '501', 'length': 11},
    'BJ': {'code': '229', 'length': 11},
    'BM': {'code': '1441', 'length': 11},
    'BT': {'code': '975', 'length': 11},
    'BO': {'code': '591', 'length': 11},
    'BA': {'code': '387', 'length': 12},
    'BW': {'code': '267', 'length': 11},
    'BR': {'code': '55', 'length': 12},
    'BN': {'code': '673', 'length': 11},
    'BG': {'code': '359', 'length': 11},
    'BF': {'code': '226', 'length': 11},
    'BI': {'code': '257', 'length': 11},
    'KH': {'code': '855', 'length': 12},
    'CM': {'code': '237', 'length': 11},
    'CA': {'code': '1', 'length': 11},
    'CV': {'code': '238', 'length': 11},
    'KY': {'code': '1345', 'length': 11},
    'CF': {'code': '236', 'length': 11},
    'TD': {'code': '235', 'length': 11},
    'CL': {'code': '56', 'length': 12},
    'CN': {'code': '86', 'length': 13},
    'CO': {'code': '57', 'length': 12},
    'KM': {'code': '269', 'length': 11},
    'CR': {'code': '506', 'length': 11},
    'HR': {'code': '385', 'length': 11},
    'CU': {'code': '53', 'length': 11},
    'CW': {'code': '599', 'length': 11},
    'CY': {'code': '357', 'length': 11},
    'CZ': {'code': '420', 'length': 12},
    'CD': {'code': '243', 'length': 11},
    'DK': {'code': '45', 'length': 11},
    'DJ': {'code': '253', 'length': 11},
    'DM': {'code': '1767', 'length': 11},
    'DO': {'code': '1809', 'length': 11},
    'EC': {'code': '593', 'length': 11},
    'EG': {'code': '20', 'length': 12},
    'SV': {'code': '503', 'length': 11},
    'GQ': {'code': '240', 'length': 11},
    'ER': {'code': '291', 'length': 11},
    'EE': {'code': '372', 'length': 11},
    'ET': {'code': '251', 'length': 11},
    'FK': {'code': '500', 'length': 11},
    'FJ': {'code': '679', 'length': 11},
    'FI': {'code': '358', 'length': 12},
    'FR': {'code': '33', 'length': 11},
    'PF': {'code': '689', 'length': 11},
    'GA': {'code': '241', 'length': 11},
    'GM': {'code': '220', 'length': 11},
    'GE': {'code': '995', 'length': 12},
    'DE': {'code': '49', 'length': 12},
    'GH': {'code': '233', 'length': 12},
    'GI': {'code': '350', 'length': 11},
    'GR': {'code': '30', 'length': 12},
    'GL': {'code': '299', 'length': 11},
    'GD': {'code': '1473', 'length': 11},
    'GU': {'code': '1671', 'length': 11},
    'GT': {'code': '502', 'length': 11},
    'GG': {'code': '44148', 'length': 11},
    'GN': {'code': '224', 'length': 11},
    'GW': {'code': '245', 'length': 11},
    'GY': {'code': '592', 'length': 11},
    'HT': {'code': '509', 'length': 11},
    'HN': {'code': '504', 'length': 11},
    'HK': {'code': '852', 'length': 11},
    'HU': {'code': '36', 'length': 12},
    'IS': {'code': '354', 'length': 11},
    'IN': {'code': '91', 'length': 12},
    'ID': {'code': '62', 'length': 12},
    'IR': {'code': '98', 'length': 12},
    'IQ': {'code': '964', 'length': 12},
    'IE': {'code': '353', 'length': 11},
    'IM': {'code': '441624', 'length': 11},
    'IL': {'code': '972', 'length': 12},
    'IT': {'code': '39', 'length': 12},
    'CI': {'code': '225', 'length': 11},
    'JM': {'code': '1876', 'length': 11},
    'JP': {'code': '81', 'length': 12},
    'JE': {'code': '441534', 'length': 11},
    'JO': {'code': '962', 'length': 12},
    'KZ': {'code': '7', 'length': 12},
    'KE': {'code': '254', 'length': 12},
    'KI': {'code': '686', 'length': 11},
    'XK': {'code': '383', 'length': 11},
    'KW': {'code': '965', 'length': 12},
    'KG': {'code': '996', 'length': 12},
    'LA': {'code': '856', 'length': 12},
    'LV': {'code': '371', 'length': 11},
    'LB': {'code': '961', 'length': 11},
    'LS': {'code': '266', 'length': 11},
    'LR': {'code': '231', 'length': 12},
    'LY': {'code': '218', 'length': 12},
    'LI': {'code': '423', 'length': 11},
    'LT': {'code': '370', 'length': 12},
    'LU': {'code': '352', 'length': 11},
    'MO': {'code': '853', 'length': 11},
    'MK': {'code': '389', 'length': 12},
    'MG': {'code': '261', 'length': 12},
    'MW': {'code': '265', 'length': 12},
    'MY': {'code': '60', 'length': 12},
    'MV': {'code': '960', 'length': 11},
    'ML': {'code': '223', 'length': 11},
    'MT': {'code': '356', 'length': 11},
    'MH': {'code': '692', 'length': 11},
    'VC': {'code': '1784', 'length': 11},
    'WS': {'code': '685', 'length': 11},
    'SM': {'code': '378', 'length': 11},
    'ST': {'code': '239', 'length': 11},
    'SA': {'code': '966', 'length': 12},
    'SN': {'code': '221', 'length': 11},
    'RS': {'code': '381', 'length': 12},
    'SC': {'code': '248', 'length': 11},
    'SL': {'code': '232', 'length': 11},
    'SG': {'code': '65', 'length': 11},
    'SK': {'code': '421', 'length': 12},
    'SI': {'code': '386', 'length': 11},
    'SB': {'code': '677', 'length': 11},
    'SO': {'code': '252', 'length': 11},
    'ZA': {'code': '27', 'length': 12},
    'KR': {'code': '82', 'length': 12},
    'SS': {'code': '211', 'length': 12},
    'ES': {'code': '34', 'length': 11},
    'LK': {'code': '94', 'length': 12},
    'SD': {'code': '249', 'length': 12},
    'SR': {'code': '597', 'length': 11},
    'SZ': {'code': '268', 'length': 11},
    'SE': {'code': '46', 'length': 12},
    'CH': {'code': '41', 'length': 12},
    'SY': {'code': '963', 'length': 12},
    'TW': {'code': '886', 'length': 12},
    'TJ': {'code': '992', 'length': 12},
    'TZ': {'code': '255', 'length': 12},
    'TH': {'code': '66', 'length': 12},
    'TL': {'code': '670', 'length': 11},
    'TG': {'code': '228', 'length': 11},
    'TK': {'code': '690', 'length': 11},
    'TO': {'code': '676', 'length': 11},
    'TT': {'code': '1868', 'length': 11},
    'TN': {'code': '216', 'length': 12},
    'TR': {'code': '90', 'length': 12},
    'TM': {'code': '993', 'length': 12},
    'TC': {'code': '1649', 'length': 11},
    'TV': {'code': '688', 'length': 11},
    'UG': {'code': '256', 'length': 12},
    'UA': {'code': '380', 'length': 12},
    'AE': {'code': '971', 'length': 12},
    'GB': {'code': '44', 'length': 12},
    'UY': {'code': '598', 'length': 12},
    'UZ': {'code': '998', 'length': 12},
    'VU': {'code': '678', 'length': 11},
    'VA': {'code': '379', 'length': 11},
    'VE': {'code': '58', 'length': 12},
    'VN': {'code': '84', 'length': 12},
    'VI': {'code': '1340', 'length': 11},
    'YE': {'code': '967', 'length': 12},
    'ZM': {'code': '260', 'length': 12},
    'ZW': {'code': '263', 'length': 12},
  };

  if (!countries.containsKey(countryCode)) return false;
  String dialCode = countries[countryCode]!['code'];
  int validLength = countries[countryCode]!['length'];
  String digits = phone.substring(1);
  if (!RegExp(r'^\d+$').hasMatch(digits)) return null;
  if (!digits.startsWith(dialCode)) return null;
  if (phone.length != validLength) return null;

  return '+$dialCode $digits ${LocaleKeys.not_valid_number.tr()}';
}
