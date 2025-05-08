import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/helper/constants.dart';

final ziaratProvider = ChangeNotifierProvider<ZiaratNotifier>((ref) => ZiaratNotifier());

class ZiaratNotifier extends ChangeNotifier {
  ZiaratCities? selectedCity;
  ZiaratDestinationsCreationOptions? selectedCreationOption;

  updateSelectedCity(ZiaratCities city) {
    selectedCity = city;
    notifyListeners();
  }

  updateSelectedCreationOption(ZiaratDestinationsCreationOptions option) {
    selectedCreationOption = option;
    notifyListeners();
  }

  reset() {
    selectedCity = null;
    selectedCreationOption = null;
    notifyListeners();
  }
}
