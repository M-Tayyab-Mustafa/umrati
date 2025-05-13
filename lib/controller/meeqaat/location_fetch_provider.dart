import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/services/local_storage.dart';
import '../../view/meeqaat/three_tasks.dart';
import '../../view/nav/page.dart';

final locationFetchProvider = ChangeNotifierProvider<MeeqaatLocationFetchProviderNotifier>((ref) => MeeqaatLocationFetchProviderNotifier());

class MeeqaatLocationFetchProviderNotifier extends ChangeNotifier {
  String location = '';
  getLocation() async {
    var position = await Geolocator.getCurrentPosition();
    Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
    location = '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
  }

  void skip(BuildContext context) {
    LocalStorageManager.showLocationFetchPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage()));
  }

  void continueTab(BuildContext context) async {
    LocalStorageManager.showLocationFetchPage(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeeqaatThreeTasksPage()));
  }
}
