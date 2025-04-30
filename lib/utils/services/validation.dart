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

String? simpleFieldValidation(String? value, String fieldName) {
  value = value?.trim();
  if (value == null || value.isEmpty) {
    return '$fieldName field can\'t be empty';
  } else {
    return null;
  }
}

String? restrictedNamesValidation(String? value, String fieldName, {bool fullValidation = true}) {
  value = value?.trim();
  if ((value == null || value.isEmpty) && fullValidation) {
    return '$fieldName field can\'t be empty';
  } else if ((value?.toLowerCase().contains('admin') ?? false) || (value?.toLowerCase().contains('superadmin') ?? false) || (value?.toLowerCase().contains('administrator') ?? false) || (value?.toLowerCase().contains('super') ?? false) || (value?.toLowerCase().contains('superadministrator') ?? false)) {
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
