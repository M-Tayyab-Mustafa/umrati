import '../../export.dart';

Future<bool?> errorToast(String msg) async {
  return await Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red, textColor: Colors.white, gravity: ToastGravity.TOP, fontSize: 16.sp);
}

Future<bool?> infoToast(String msg) async {
  return await Fluttertoast.showToast(msg: msg, backgroundColor: CColors.primary, textColor: Colors.white, gravity: ToastGravity.TOP, fontSize: 16.sp);
}
