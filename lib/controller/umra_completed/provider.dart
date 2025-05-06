import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/tawaf/start.dart';

final umraCompletedProvider = ChangeNotifierProvider<UmraCompletedNotifier>((ref) => UmraCompletedNotifier());

class UmraCompletedNotifier extends ChangeNotifier {
  goToHomePage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartTawafPage()));
  }
}
