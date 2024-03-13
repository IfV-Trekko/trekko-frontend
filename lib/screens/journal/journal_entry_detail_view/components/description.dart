import 'package:app_backend/model/trip/tracked_point.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/path_showcase.dart';
import 'package:app_frontend/components/picker/kilometer_picker.dart';
import 'package:app_frontend/components/picker/time_picker.dart';
import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:intl/intl.dart';
import 'package:fling_units/fling_units.dart';

class Description extends StatefulWidget {
  final Trip trip;
  final DateTime startDate;
  final DateTime endDate;

  const Description({
    required this.trip,
    required this.startDate,
    required this.endDate,
    Key? key,
  }) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Future<String> _getStreet(TrackedPoint where) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(where.latitude, where.longitude);
    if (placemarks.isNotEmpty && placemarks.first.street!.isNotEmpty) {
      return _formatStreet(placemarks.first);
    }
    return "-";
  }

  Future<String> _getLocality(TrackedPoint where) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(where.latitude, where.longitude);
    if (placemarks.isNotEmpty && placemarks.first.street!.isNotEmpty) {
      return _formatLocality(placemarks.first);
    }
    return "-";
  }

  String _formatStreet(Placemark placemark) {
    return '${placemark.street}';
  }

  String _formatLocality(Placemark placemark) {
    return '${placemark.locality}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        color: AppThemeColors.contrast0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                TimePicker(
                  initialDateTime: widget.startDate,
                  maximumDateTime: widget.endDate,
                  onChange: (val) {
                    widget.trip.startTime = val;
                    TrekkoProvider.of(context).saveTrip(widget.trip);
                  },
                ),
                const Spacer(),
                KilometerPicker(
                    value: widget.trip.getDistance().as(kilo.meters),
                    onChange: (val) {
                      widget.trip.setDistance(val?.kilo.meters);
                      TrekkoProvider.of(context).saveTrip(widget.trip);
                    }),
                const Spacer(),
                TimePicker(
                  onChange: (val) {
                    widget.trip.endTime = val;
                    TrekkoProvider.of(context).saveTrip(widget.trip);
                  },
                  initialDateTime: widget.endDate,
                  minimumDateTime: widget.startDate,
                ),
              ],
            ),
            const SizedBox(height: 16),
            PathShowcase(trip: widget.trip),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: FutureBuilder(
                      future: _getStreet(
                          widget.trip.legs.first.trackedPoints.first),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!,
                              style: AppThemeTextStyles.small);
                        } else if (snapshot.hasError) {
                          return Text('-', style: AppThemeTextStyles.small);
                        }
                        return const CupertinoActivityIndicator();
                      }),
                ),
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FutureBuilder(
                        future: _getStreet(
                            widget.trip.legs.last.trackedPoints.last),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!,
                                style: AppThemeTextStyles.small);
                          } else if (snapshot.hasError) {
                            return Text('-', style: AppThemeTextStyles.small);
                          }
                          return const CupertinoActivityIndicator();
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: FutureBuilder(
                      future: _getLocality(
                          widget.trip.legs.first.trackedPoints.first),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!,
                              style: AppThemeTextStyles.small
                                  .copyWith(color: AppThemeColors.contrast700));
                        } else if (snapshot.hasError) {
                          return Text('-',
                              style: AppThemeTextStyles.small
                                  .copyWith(color: AppThemeColors.contrast700));
                        }
                        return const CupertinoActivityIndicator();
                      }),
                ),
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FutureBuilder(
                        future: _getLocality(
                            widget.trip.legs.last.trackedPoints.last),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!,
                                style: AppThemeTextStyles.small.copyWith(
                                    color: AppThemeColors.contrast700));
                          } else if (snapshot.hasError) {
                            return Text('-',
                                style: AppThemeTextStyles.small.copyWith(
                                    color: AppThemeColors.contrast700));
                          }
                          return const CupertinoActivityIndicator();
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                    DateFormat('EE, dd MMM yyyy', "de")
                        .format(widget.startDate),
                    style: AppThemeTextStyles.tiny),
                const Spacer(),
                Text(DateFormat('EE, dd MMM yyyy', "de").format(widget.endDate),
                    style: AppThemeTextStyles.tiny),
              ],
            )
          ],
        ));
  }
}
