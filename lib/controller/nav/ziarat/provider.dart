import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umrati/controller/nav/provider.dart';

import '../../../model/ziarat.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/toast.dart';
import '../../../view/nav/ziarat/page.dart';

final ziaratProvider = ChangeNotifierProvider<ZiaratNotifier>((ref) => ZiaratNotifier());

class ZiaratNotifier extends ChangeNotifier {
  ZiaratCities? selectedCity;
  List<ZiaratModel> selectedZiarat = [];
  List<ZiaratModel> ziarat = [ZiaratModel(title: 'Mawlid al-Nabi', lat: '21.4225', lng: '39.8262')];

  //* Creating Class Level Variables
  bool showCreationOptionPage = false;
  ZiaratDestinationsCreationOptions? selectedCreationOption;

  //* Auto Generated Ziarat Class Level Variables
  bool showAutoSelectionPage = false;

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

  void goBack() {
    showCreationOptionPage = false;
    reset();
  }

  void goToDestinationGenerationPage() {
    showCreationOptionPage = true;
    notifyListeners();
  }

  updateSelectedZiarat(ZiaratModel ziarat) {
    if (selectedZiarat.contains(ziarat)) {
      selectedZiarat.remove(ziarat);
    } else {
      selectedZiarat.add(ziarat);
    }
    notifyListeners();
  }

  void generateZiarat(BuildContext context, WidgetRef ref) async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      var status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
        errorToast('Location permission denied, Permission Required to proceed for ward.');
        return;
      }
    } else if (status == LocationPermission.deniedForever) {
      await openAppSettings();
      return;
    }
    if (selectedCreationOption == ZiaratDestinationsCreationOptions.manual) {
      selectedZiarat.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ManualSelection()));
    } else {
      ref.read(bottomNavProvider.notifier).updateLogoAlign(MainAxisAlignment.start);
      showAutoSelectionPage = true;
      notifyListeners();
    }
  }

  getLocation() async {
    var position = await Geolocator.getCurrentPosition();
    Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
    return '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
  }

  void createZiaratRoute() {}
}
