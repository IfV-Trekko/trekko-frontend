import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/trip/position_collection.dart';
import 'package:trekko_frontend/components/path_showcase.dart';

class VehicleLine extends StatelessWidget {
  final PositionCollection data;

  const VehicleLine({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20.0, top: 12),
        child: PathShowcase(data: data));
  }
}