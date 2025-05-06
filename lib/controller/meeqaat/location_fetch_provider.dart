import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../view/meeqaat/three_tasks.dart';

final locationFetchProvider = ChangeNotifierProvider<MeeqaatLocationFetchProviderNotifier>((ref) => MeeqaatLocationFetchProviderNotifier());

class MeeqaatLocationFetchProviderNotifier extends ChangeNotifier {
  String location = '';
  getLocation() async {
    var position = await Geolocator.getCurrentPosition();
    Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
    location = '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
  }

  void skip(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatThreeTasksPage()));
  }

  void continueTab(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeeqaatThreeTasksPage()));
  }
}
