import 'package:trekko_backend/controller/utils/trip_builder.dart';
import 'package:trekko_backend/model/trip/leg.dart';
import 'package:trekko_backend/model/trip/tracked_point.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_backend/model/trip/trip.dart';

class TripConstants {
  static Leg createDefaultLeg(DateTime from, {latStart = 49.009698, lonStart = 8.415515}) {
    DateTime to = from.add(const Duration(minutes: 10));
    double latEnd = latStart + latDegreesPerMeter * 650;
    return Leg.withData(TransportType.by_foot, [
      TrackedPoint.withData(49.009698, 8.415515, from),
      TrackedPoint.withData(latEnd, lonStart, to),
    ]);
  }

  static Trip createDefaultTrip(DateTime from) {
    return Trip.withData([createDefaultLeg(from)]);
  }
}
