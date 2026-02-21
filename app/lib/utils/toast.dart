import 'package:edudoro/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    timeInSecForIosWeb: 5,
    backgroundColor: secondary,
    textColor: primary,
    gravity: ToastGravity.TOP,
    toastLength: Toast.LENGTH_LONG,
  );
}
