import '../../../export.dart';
import '../../../view/nav/home/ziarat/map.dart';
import '../../../view/nav/home/ziarat/page.dart';

final ziaratProvider = ChangeNotifierProvider<ZiaratNotifier>((ref) => ZiaratNotifier());

class ZiaratNotifier extends ChangeNotifier {
  ZiaratCities? selectedCity;
  WidgetRef? ref;
  List<ZiaratModel> selectedZiarat = [];
  List<ZiaratModel> ziarats = [];
  List<ZiaratModel> sortedZiarats = [];
  StreamSubscription<Position>? positionStream;
  bool isLoading = false;

  String myCurrentLocation = '';

  //* Creating Class Level Variables
  bool showCreationOptionPage = false;
  ZiaratDestinationsCreationOptions? selectedCreationOption;

  //* Auto Generated Ziarat Class Level Variables
  bool showAutoSelectionPage = false;

  UserModel? user;

  initialization(BuildContext context, WidgetRef ref) async {
    user = await LocalStorageManager.getUser();
    this.ref = ref;
    var data = (await userCollection.doc(user!.uid).get()).data()!;
    selectedZiarat = List.from(data[CommonField.selectedZiarat.name]).map((e) => ZiaratModel.fromMap(e)).toList();
    if (selectedZiarat.isNotEmpty) {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyDialog(isDoingUmera: false));
      if (result == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ZiaratMapPage()));
      } else {
        await userCollection.doc(user!.uid).set({CommonField.selectedZiarat.name: []}, SetOptions(merge: true));
        selectedZiarat.clear();
      }
    }
    myCurrentLocation = await getLocation();
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
    showCreationOptionPage = false;
    showAutoSelectionPage = false;
    positionStream?.cancel();
    selectedZiarat.clear();
    sortedZiarats.clear();
    isLoading = false;
    notifyListeners();
  }

  void goBackToSelectCities() {
    showCreationOptionPage = false;
    reset();
  }

  void goToBackFromAutoSelectionPage() {
    ref?.read(bottomNavProvider.notifier).updateLogoAlign(Alignment.center);
    showAutoSelectionPage = false;
    positionStream?.cancel();
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

  void generateZiarat(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      ziarats = List.from((await settingsCollection.doc(CommonDoc.ziarat.name).get()).data()![selectedCity?.name]).map<ZiaratModel>((map) => ZiaratModel.fromMap(map)).toList();
      var status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
        var status = await Geolocator.requestPermission();
        if (status == LocationPermission.deniedForever) {
          await openAppSettings();
          return;
        } else if (status == LocationPermission.denied) {
          errorToast(LocaleKeys.location_permission_denied_permission_is_required_to_proceed_forward.tr());
          return;
        }
      }
      if (selectedCreationOption == ZiaratDestinationsCreationOptions.manual) {
        selectedZiarat.clear();
        isLoading = false;
        notifyListeners();
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ManualSelection()));
      } else {
        ref?.read(bottomNavProvider.notifier).updateLogoAlign(Alignment.centerLeft);
        showAutoSelectionPage = true;
      }
    } catch (e) {
      log(e.toString());
      errorToast(LocaleKeys.something_went_wrong_please_try_again_later.tr());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getLocation() async {
    var position = await Geolocator.getCurrentPosition();
    Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
    return '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
  }

  Future<void> getDistance() async {
    positionStream = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.best)).listen((position) async {
      sortedZiarats =
          ziarats.map<ZiaratModel>((ziarat) {
            var distance = Geolocator.distanceBetween(position.latitude, position.longitude, ziarat.lat.toDouble(), ziarat.lng.toDouble());
            return ziarat.copyWith(distance: (distance / 1000).toStringAsFixed(0));
          }).toList();
      sortedZiarats.sort((a, b) => int.parse(a.distance).compareTo(int.parse(b.distance)));
      notifyListeners();
    });
  }

  void createZiaratRoute(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    var user = await LocalStorageManager.getUser();
    await userCollection.doc(user!.uid).set({
      CommonField.selectedZiarat.name: (selectedCreationOption == ZiaratDestinationsCreationOptions.auto ? sortedZiarats : selectedZiarat).map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true));
    isLoading = false;
    notifyListeners();
    if (selectedCreationOption == ZiaratDestinationsCreationOptions.manual) {
      Navigator.pop(context);
    }
    goToBackFromAutoSelectionPage();
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ZiaratMapPage()));
    selectedZiarat.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
}
