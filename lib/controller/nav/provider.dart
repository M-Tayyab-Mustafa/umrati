import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/export.dart';

import '../../view/nav/umera/tawaf.dart';
import '../../utils/helper/constants.dart';
import '../../view/nav/ziarat/page.dart';

final bottomNavProvider = ChangeNotifierProvider<BottomNavNotifier>((ref) => BottomNavNotifier());

class BottomNavNotifier extends ChangeNotifier {
  BottomNavTabs selectedTab = BottomNavTabs.umera;
  Widget child = const StartTawafPage();

  var logoAlign = MainAxisAlignment.center;

  void onBottomNavTap(BottomNavTabs selectedOption) {
    logoAlign = MainAxisAlignment.center;
    selectedTab = selectedOption;
    switch (selectedOption) {
      case BottomNavTabs.profile:
        _setMyLocationToMacca();
        break;
      case BottomNavTabs.umera:
        child = const StartTawafPage();
        break;
      case BottomNavTabs.more:
        break;
      case BottomNavTabs.ziarat:
        child = const ZiaratPage();
        break;
      default:
        child = Scaffold();
    }
    notifyListeners();
  }

  void updateChild(Widget child) {
    this.child = child;
    notifyListeners();
  }

  void updateLogoAlign(MainAxisAlignment align) {
    logoAlign = align;
    notifyListeners();
  }

  void _setMyLocationToMacca() async {
    await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition();
    await settingsCollection.doc(CommonDoc.alKaba.name).update({'lat': position.latitude, 'lng': position.longitude});
    await settingsCollection.doc(CommonDoc.safaMarwa.name).update({'safaLat': position.latitude, 'safaLng': position.longitude});
    LatLng marwaNewLocation = offsetLatLng(
      LatLng(position.latitude, position.longitude),
      double.tryParse((await settingsCollection.doc(CommonDoc.safaMarwa.name).get()).data()!['distance'] as String) ?? 450,
      0,
    );
    await settingsCollection.doc(CommonDoc.safaMarwa.name).update({'marwaLat': marwaNewLocation.latitude, 'marwaLng': marwaNewLocation.longitude});
  }
}

LatLng offsetLatLng(LatLng origin, double distanceInMeters, double bearingInDegrees) {
  const double earthRadius = 6371000;
  final double bearing = bearingInDegrees * pi / 180;

  final double lat1 = origin.latitude * pi / 180;
  final double lon1 = origin.longitude * pi / 180;

  final double lat2 = asin(sin(lat1) * cos(distanceInMeters / earthRadius) + cos(lat1) * sin(distanceInMeters / earthRadius) * cos(bearing));

  final double lon2 = lon1 + atan2(sin(bearing) * sin(distanceInMeters / earthRadius) * cos(lat1), cos(distanceInMeters / earthRadius) - sin(lat1) * sin(lat2));

  return LatLng(lat2 * 180 / pi, lon2 * 180 / pi);
}
