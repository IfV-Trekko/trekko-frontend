import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/journal/entry/components/information_row.dart';
import 'package:trekko_frontend/screens/journal/entry/components/label_row.dart';
import 'package:trekko_frontend/screens/journal/entry/components/vehicle_line.dart';

class PositionCollectionEntry extends StatefulWidget {
  final PositionCollection data;
  final Trekko trekko;
  final Function(PositionCollection) onTap;

  const PositionCollectionEntry(
      {required this.trekko,
      required this.data,
      super.key,
      required this.onTap});

  @override
  State<PositionCollectionEntry> createState() =>
      _PositionCollectionEntryState();
}

class _PositionCollectionEntryState extends State<PositionCollectionEntry> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      widget.onTap(widget.data);
    }, child: LayoutBuilder(builder: (context, constraints) {
      return Container(
        width:
            constraints.constrainWidth(MediaQuery.of(context).size.width - 32),
        decoration: BoxDecoration(
          color: AppThemeColors.contrast0,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: AppThemeColors.contrast400,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 10),
          child: Column(
            children: [
              InformationRow(data: widget.data),
              VehicleLine(data: widget.data),
              LabelRow(data: widget.data),
            ],
          ),
        ),
      );
    }));
  }
}
