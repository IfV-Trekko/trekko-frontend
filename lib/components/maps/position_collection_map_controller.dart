import 'package:trekko_backend/model/trip/tracked_point.dart';

class PositionCollectionMapController {

  Function(TrackedPoint)? onPointAdded;
  Function(TrackedPoint)? onPointRemoved;

  void addPoint(TrackedPoint point) {
    onPointAdded?.call(point);
  }

  void removePoint(TrackedPoint point) {
    onPointRemoved?.call(point);
  }
}