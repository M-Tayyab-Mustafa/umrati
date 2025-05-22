import 'dart:async' show StreamSubscription;
import 'dart:developer';

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
  List<ZiaratModel> ziarats = [];

  StreamSubscription<Position>? positionStream;

  bool isLoading = false;

  //* Creating Class Level Variables
  bool showCreationOptionPage = false;
  ZiaratDestinationsCreationOptions? selectedCreationOption;

  //* Auto Generated Ziarat Class Level Variables
  bool showAutoSelectionPage = false;

  getSelectedCityZiarat() async {
    ziarats = List.from((await settingsCollection.doc(CommonDoc.ziarat.name).get()).data()![selectedCity?.name]).map<ZiaratModel>((map) => ZiaratModel.fromMap(map)).toList();
  }

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
    showAutoSelectionPage = false;
    positionStream?.cancel();
    notifyListeners();
  }

  void goBackToSelectCities() {
    showCreationOptionPage = false;
    reset();
  }

  void goToAutoSelectionPage() {
    showAutoSelectionPage = false;
    notifyListeners();
  }

  void goToDestinationGenerationPage() {
    showCreationOptionPage = true;
    positionStream?.cancel();
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
    isLoading = true;
    notifyListeners();
    try {
      await getSelectedCityZiarat();
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
      }
    } catch (e) {
      log(e.toString());
      errorToast('Something went wrong, Please try again later.');
    }
    isLoading = false;
    notifyListeners();
  }

  getLocation() async {
    var position = await Geolocator.getCurrentPosition();
    Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
    return '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
  }

  Future<void> getDistance() async {
    positionStream = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.best)).listen((position) async {
      ziarats =
          ziarats.map<ZiaratModel>((ziarat) {
            var distance = Geolocator.distanceBetween(position.latitude, position.longitude, ziarat.lat.toDouble(), ziarat.lng.toDouble());
            return ziarat.copyWith(distance: (distance / 1000).toStringAsFixed(0));
          }).toList();

      ziarats.sort((a, b) => int.parse(a.distance).compareTo(int.parse(b.distance)));

      notifyListeners();
    });
  }

  void createZiaratRoute() {}

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
}
