import 'package:flutter/cupertino.dart';

class PopUpUtils {
  static void showPopUp(BuildContext context, String title, String message) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
