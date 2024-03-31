import 'package:trekko_backend/controller/trekko.dart';
import 'package:flutter/cupertino.dart';

class TrekkoProvider extends InheritedWidget {
  final Trekko trekko;

  const TrekkoProvider({required this.trekko, required Widget child, Key? key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(TrekkoProvider oldWidget) {
    return trekko != oldWidget.trekko;
  }

  static Trekko of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TrekkoProvider>()!.trekko;
  }
}
