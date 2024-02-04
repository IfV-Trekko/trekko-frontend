import 'package:flutter/cupertino.dart';

class JournalEntryDetailViewProvider extends InheritedWidget {
  //TODO Trip instanz auch durchreichen
  bool hasUnsafedChanges;
  Function(bool unsafedChanges) onSetUnsafedChanges;

  JournalEntryDetailViewProvider(
      {required this.hasUnsafedChanges,
      required this.onSetUnsafedChanges,
      required Widget child,
      Key? key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(JournalEntryDetailViewProvider oldWidget) {
    return hasUnsafedChanges != oldWidget.hasUnsafedChanges;
  }

  static bool of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<JournalEntryDetailViewProvider>()!
        .hasUnsafedChanges;
  }

  static void updateOf(BuildContext context, bool hasUnsafedChanges) {
    context
        .dependOnInheritedWidgetOfExactType<JournalEntryDetailViewProvider>()!
        .onSetUnsafedChanges(hasUnsafedChanges);
  }
}
