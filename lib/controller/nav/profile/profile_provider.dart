import '../../../export.dart';

final profileProvider = ChangeNotifierProvider.autoDispose<ProfileNotifier>((ref) => ProfileNotifier());

class ProfileNotifier extends ChangeNotifier {
  bool isLoading = false;

  void setMyLocationToMecca() async {
    try {
      isLoading = true;
      notifyListeners();
      var position = await Geolocator.getCurrentPosition();
      await settingsCollection
          .doc(CommonDoc.alKaba.name)
          .update({'lat': position.latitude, 'lng': position.longitude})
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      await settingsCollection
          .doc(CommonDoc.safaMarwa.name)
          .update({'safaLat': position.latitude, 'safaLng': position.longitude})
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      LatLng marwaNewLocation = offsetLatLng(
        LatLng(position.latitude, position.longitude),
        double.tryParse((await settingsCollection.doc(CommonDoc.safaMarwa.name).get()).data()!['distance'] as String) ?? 450,
        0,
      );
      await settingsCollection
          .doc(CommonDoc.safaMarwa.name)
          .update({'marwaLat': marwaNewLocation.latitude, 'marwaLng': marwaNewLocation.longitude})
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      infoToast('Location Set');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorToast(e.toString());
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

  void setOriginalLocation() async {
    try {
      isLoading = true;
      notifyListeners();
      await settingsCollection.doc(CommonDoc.alKaba.name).update({'lat': 21.422487, 'lng': 39.826206}).timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      await settingsCollection
          .doc(CommonDoc.safaMarwa.name)
          .update({'safaLat': 21.422933, 'safaLng': 39.827145})
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      await settingsCollection
          .doc(CommonDoc.safaMarwa.name)
          .update({'marwaLat': 21.423713, 'marwaLng': 39.828450})
          .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
      infoToast('Location Set');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorToast(e.toString());
    }
  }
}
