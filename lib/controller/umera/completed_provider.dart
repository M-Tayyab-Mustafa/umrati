import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/umera/start_tawaf.dart';

final umraCompletedProvider = ChangeNotifierProvider<UmraCompletedNotifier>((ref) => UmraCompletedNotifier());

class UmraCompletedNotifier extends ChangeNotifier {
  goToHomePage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartTawafPage()));
  }
}
