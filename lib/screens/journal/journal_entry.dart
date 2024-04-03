import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/trip/trip.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:trekko_frontend/components/path_showcase.dart';
import 'package:trekko_frontend/screens/journal/journal_detail/donation_box.dart';
import 'package:trekko_frontend/screens/journal/journal_detail/journal_entry_context_menu.dart';
import 'package:trekko_frontend/screens/journal/journal_detail/purpose_box.dart';
import 'package:trekko_frontend/screens/journal/journal_detail/vehicle_box.dart';
import 'package:trekko_frontend/screens/journal/journal_entry_detail_view/journal_entry_detail_view.dart';

//renders the journal entry cards showing the trip information
class JournalEntry extends StatelessWidget {
  final Trip trip;
  final bool selectionMode;
  final bool isSelected;
  final bool isDisabled;
  final Function(Trip, bool)? onSelectionChanged;
  final Trekko trekko;

  JournalEntry(this.trip, this.selectionMode, this.trekko,
      {this.onSelectionChanged,
      this.isSelected = false,
      this.isDisabled = false,
      Key? key})
      : super(key: key ?? ValueKey(trip.id));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isDisabled) return;

        if (selectionMode && onSelectionChanged != null) {
          onSelectionChanged!(trip, !isSelected);
        }
      },
      child: Row(
        children: [
          if (selectionMode)
            ClipRect(
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoCheckbox(
                    shape: const CircleBorder(),
                    activeColor: AppThemeColors.blue,
                    value: isSelected,
                    onChanged: (value) {
                      if (onSelectionChanged != null) {
                        onSelectionChanged!(trip, !isSelected);
                      }
                    },
                  )),
            ),
          if (selectionMode) const SizedBox(width: 16.0),
          Expanded(
            child: selectionMode
                ? _buildEntry()
                : JournalEntryContextMenu(
                    trip: trip,
                    onDonate: () async {
                      trekko.donate(createQuery().build());
                    },
                    onRevoke: () async {
                      trekko.revoke(createQuery().build());
                    },
                    onDelete: () async {
                      trekko.deleteTrip(createQuery().build());
                    },
                    onEdit: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  JournalEntryDetailView(trip)));
                    },
                    buildEntry: _buildEntry,
                  ),
          ),
        ],
      ),
    );
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> createQuery() {
    return trekko.getTripQuery().filter().idEqualTo(trip.id);
  }

  Widget _buildEntry() {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          if (isDisabled) return;
          if (selectionMode) {
            if (onSelectionChanged != null) {
              onSelectionChanged!(trip, !isSelected);
            }
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => JournalEntryDetailView(trip)));
          }
        },
        child: Container(
          width: constraints.constrainWidth(MediaQuery.of(context).size.width - 32),
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
                _InformationRow(trip),
                _VehicleLine(trip),
                _LabelRow(trip),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _InformationRow extends StatelessWidget {
  final Trip trip;

  const _InformationRow(this.trip);

  @override
  Widget build(BuildContext context) {
    Duration duration = trip.calculateDuration();
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            DateFormat('HH:mm').format(trip.getStartTime()),
            style: AppThemeTextStyles.largeTitle.copyWith(letterSpacing: -1),
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(hours > 0 ? "$hours h $minutes min" : "$minutes min",
                    style: TextStyle(
                        color: TransportDesign.getColor(
                            trip.getTransportTypes().first))),
                const SizedBox(width: 4.0),
                Text(
                  "- ${trip.getDistance().as(kilo.meters).toStringAsFixed(1)} km",
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Text(
            DateFormat('HH:mm').format(trip.getEndTime()),
            style: AppThemeTextStyles.largeTitle.copyWith(letterSpacing: -1),
          ),
        ),
      ],
    );
  }
}

class _VehicleLine extends StatelessWidget {
  final Trip trip;

  const _VehicleLine(this.trip);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20.0, top: 12),
        child: PathShowcase(trip: trip));
  }
}

class _LabelRow extends StatelessWidget {
  final Trip trip;

  const _LabelRow(this.trip);

  @override
  Widget build(BuildContext context) {
    final uniqueVehicleTypes = trip.getTransportTypes();

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 6.0,
        runSpacing: 6.0,
        children: [
          for (var vehicleType in uniqueVehicleTypes)
            Wrap(
              children: [
                VehicleBox(vehicleType, showText: true),
              ],
            ),
          if (trip.purpose != null && trip.purpose!.isNotEmpty)
            PurposeBox(trip.purpose.toString()),
          DonationBox(trip.donationState),
        ],
      ),
    );
  }
}
