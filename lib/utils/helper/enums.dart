part of 'constants.dart';

enum Gender { male, female, unknown }

enum BackgroundType { empty, logo, logoWithBackButton, logoWithSkip }

enum BottomNavTabs { profile, supplications, home, prayer, settings }

enum ZiaratCities { macca, medina, taif, other }

enum ZiaratDestinationsCreationOptions { auto, manual }

enum CollectionNames { users, settings }

enum MapMarkerId { userLocation, destination }

enum MapPolylineId { route }

enum CommonDoc {
  alKaba('al_kaba'),
  safaMarwa('safa_marwa'),
  ziarat('ziarat');

  final String name;

  const CommonDoc(this.name);
}

enum CommonField {
  isInTawaf('isInTawaf'),
  startingPoint('startingPoint'),
  selectedZiarat('selected_ziarat');

  final String name;

  const CommonField(this.name);
}
