import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme/colors.dart';

Future<bool?> errorToast(String msg) async {
  return await Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red, textColor: Colors.white, gravity: ToastGravity.TOP);
}

Future<bool?> infoToast(String msg) async {
  return await Fluttertoast.showToast(msg: msg, backgroundColor: CColors.primary, textColor: Colors.white, gravity: ToastGravity.TOP);
}
