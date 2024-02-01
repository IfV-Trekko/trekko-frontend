import 'package:app_backend/model/trip/tracked_point.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/kilometer_picker.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/components/time_picker.dart';
import 'package:app_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view_provider.dart';
import 'package:app_frontend/trekko_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:intl/intl.dart';
import 'package:fling_units/fling_units.dart';

class JournalEntryDetailViewDescription extends StatefulWidget {
  final Trip trip;
  final DateTime startDate;
  final DateTime endDate;

  JournalEntryDetailViewDescription({
    //TODO Klasse sehr lang
    required this.trip,
    required this.startDate,
    required this.endDate,
    Key? key,
  }) : super(key: key);

  @override
  _JournalEntryDetailViewDescriptionState createState() =>
      _JournalEntryDetailViewDescriptionState();
}

class _JournalEntryDetailViewDescriptionState
    extends State<JournalEntryDetailViewDescription> {
  Future<String> _getStreet(TrackedPoint where) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(where.latitude, where.longitude);
    if (placemarks.isNotEmpty) {
      return _formatStreet(placemarks.first);
    }
    return "-";
  }

  Future<String> _getLocality(TrackedPoint where) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(where.latitude, where.longitude);
    if (placemarks.isNotEmpty) {
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
        padding: EdgeInsets.all(16),
        color: AppThemeColors.contrast0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                JournalEntryDetailViewTimePicker(
                  initialDateTime: widget.trip.calculateStartTime(),
                  maximumDateTime: widget.trip.calculateEndTime(),
                  onChange: (val) {
                    widget.trip.startTime = val;
                    JournalEntryDetailViewProvider.updateOf(context, true);
                  },
                ),
                Spacer(),
                JournalEntryDetailKilometerPicker(
                    initialValue: widget.trip.getDistance().as(kilo.meters),
                    onChange: (val) {
                      widget.trip.setDistance(val.kilo.meters);
                    }),
                Spacer(),
                JournalEntryDetailViewTimePicker(
                  onChange: (val) {
                    widget.trip.endTime = val;
                  },
                  initialDateTime: widget.trip.calculateEndTime(),
                  minimumDateTime: widget.trip.calculateStartTime(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              //TODO Platzhalter für Pathshowcase
              height: 4,
              width: double.infinity,
              color: AppThemeColors.contrast700,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                FutureBuilder(
                    future:
                        _getStreet(widget.trip.legs.first.trackedPoints.first),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!,
                            style: AppThemeTextStyles.small);
                      } else if (snapshot.hasError) {
                        return Text('-', style: AppThemeTextStyles.small);
                      }
                      return CupertinoActivityIndicator();
                    }),
                const Spacer(),
                FutureBuilder(
                    future:
                        _getStreet(widget.trip.legs.last.trackedPoints.last),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!,
                            style: AppThemeTextStyles.small);
                      } else if (snapshot.hasError) {
                        return Text('-', style: AppThemeTextStyles.small);
                      }
                      return CupertinoActivityIndicator();
                    }),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                FutureBuilder(
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
                      return CupertinoActivityIndicator();
                    }),
                const Spacer(),
                FutureBuilder(
                    future:
                        _getLocality(widget.trip.legs.last.trackedPoints.last),
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
                      return CupertinoActivityIndicator();
                    }),
              ],
            ),
            SizedBox(height: 8),
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
