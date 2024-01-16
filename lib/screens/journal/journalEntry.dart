import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class journalEntry extends StatelessWidget {

  late Stream<Trip> trip;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: AppThemeColors.contrast500,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(), //TODO Children einfügen (Labels)
          ),
        ),
      ),
    );
  }


  void onPressed(){
  }
}
