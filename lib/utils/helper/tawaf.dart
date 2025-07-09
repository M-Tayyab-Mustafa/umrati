part of '../../controller/nav/umra/umra_provider.dart';

double calculateBearing(LatLng from, LatLng to) {
  double lat1 = _degToRad(from.latitude);
  double lon1 = _degToRad(from.longitude);
  double lat2 = _degToRad(to.latitude);
  double lon2 = _degToRad(to.longitude);

  double dLon = lon2 - lon1;

  double y = sin(dLon) * cos(lat2);
  double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

  double bearing = atan2(y, x);
  return (_radToDeg(bearing) + 360) % 360; // Normalize to 0-360
}

// Helper method to calculate anti-clockwise angle difference
double antiClockwiseDelta(double from, double to) {
  double delta = from - to;
  if (delta < 0) delta += 360;
  return delta;
}

double _degToRad(double deg) => deg * pi / 180;
double _radToDeg(double rad) => rad * 180 / pi;
