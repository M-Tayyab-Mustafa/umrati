part of 'constants.dart';

enum Gender { male, female, unknown }

enum BackgroundType { empty, logo, logoWithSkip }

enum BottomNavTabs { profile, umera, more, ziarat, settings }

enum ZiaratCities { macca, medina, taif, other }

enum ZiaratDestinationsCreationOptions { auto, manual }

enum CollectionNames { users, settings }

enum CommonDoc {
  alKaba('al_kaba'),
  safaMarwa('safa_marwa');

  final String name;

  const CommonDoc(this.name);
}

enum CommonField { isInTawaf, startingPoint }
