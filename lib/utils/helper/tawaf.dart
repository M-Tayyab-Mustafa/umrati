part of '../../controller/nav/umera/tawaf_provider.dart';

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

double angleDifference(double previous, double current) {
  double diff = (current - previous + 360) % 360;
  if (diff > 180) diff -= 360; // Normalize to -180..180
  return diff;
}

double _degToRad(double deg) => deg * pi / 180;
double _radToDeg(double rad) => rad * 180 / pi;
