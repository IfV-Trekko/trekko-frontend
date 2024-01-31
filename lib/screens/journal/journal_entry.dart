import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/screens/journal/journalDetail/journalDetailBoxVehicle.dart';
import 'package:fling_units/fling_units.dart';
import 'package:flutter/cupertino.dart';
import 'journalDetail/journalDetailBox.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import 'journalDetail/journalDetailBoxDonation.dart';

class JournalEntry extends StatelessWidget {
  final Trip trip;
  final bool selectionMode;
  final bool isSelected;
  final bool isDisabled;
  final Function(Trip, bool)?
      onSelectionChanged; // Callback for selection change
  final Trekko trekko;

  JournalEntry(this.trip, this.selectionMode, this.trekko, // Modify this line
      {this.onSelectionChanged,
      this.isSelected = false,
      this.isDisabled = false,
      Key? key})
      : super(key: key ?? ValueKey(trip.id));

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width - 32;
    return GestureDetector(
      onTap: () {
        if (isDisabled) return;
        if (selectionMode) {
          if (onSelectionChanged != null) {
            onSelectionChanged!(trip, !isSelected);
          }
        } else {
          onPressed();
        }
      },
      child: Row(
        children: [
          if (selectionMode)
            ClipRect(
              //transform: Matrix4.translationValues(-16, 0, 0),
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
            child: CupertinoContextMenu(
              enableHapticFeedback: true,
              actions: <Widget>[
                Builder(
                  builder: (context) => CupertinoContextMenuAction(
                    onPressed: () {
                      if (trip.donationState == DonationState.donated) {
                        trekko.revoke(createQuery().build());
                      } else {
                        trekko.donate(createQuery().build());
                      }
                      Navigator.pop(context);
                    },
                    isDefaultAction: true,
                    trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
                    child: Text(
                      trip.donationState == DonationState.donated
                          ? 'Spende zurückziehen'
                          : 'Spenden',
                      style: AppThemeTextStyles.normal
                          .copyWith(color: AppThemeColors.contrast900),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => CupertinoContextMenuAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    trailingIcon: CupertinoIcons.share,
                    child: Text(
                      'Bearbeiten',
                      style: AppThemeTextStyles.normal
                          .copyWith(color: AppThemeColors.contrast900),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => CupertinoContextMenuAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    trailingIcon: CupertinoIcons.share,
                    child: Text(
                      'Unwiderruflich löschen',
                      style: AppThemeTextStyles.normal
                          .copyWith(color: AppThemeColors.red),
                    ),
                  ),
                ),
              ],
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                  width: constraints.constrainWidth(maxWidth),
                  decoration: BoxDecoration(
                    color: AppThemeColors.contrast0,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: AppThemeColors.contrast400,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _InformationRow(trip),
                        _VehicleLine(trip),
                        _LabelRow(trip),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void onPressed() {}

  QueryBuilder<Trip, Trip, QAfterFilterCondition> createQuery() {
    return trekko.getTripQuery().filter().idEqualTo(trip.id);
  }
}

class _InformationRow extends StatelessWidget {
  final Trip trip;

  const _InformationRow(this.trip);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('HH:mm').format(trip.calculateStartTime()),
            style: AppThemeTextStyles.largeTitle.copyWith(letterSpacing: -1),
          ),
          Row(
            children: [
              Text("${trip.getDuration().inMinutes} min"),
              const SizedBox(width: 4.0),
              Text(
                  "- ${trip.getDistance().as(kilo.meters).toStringAsFixed(1)} km"),
            ],
          ),
          Text(
            DateFormat('HH:mm').format(trip.calculateEndTime()),
            style: AppThemeTextStyles.largeTitle,
          ),
        ],
      ),
    );
  }
}

class _VehicleLine extends StatelessWidget {
  final Trip trip;

  const _VehicleLine(this.trip);

  @override
  Widget build(BuildContext context) {
    return Container(); //TODO Linie implementieren
  }
}

class _LabelRow extends StatelessWidget {
  final Trip trip;

  const _LabelRow(this.trip);

  @override
  Widget build(BuildContext context) {
    final uniqueVehicleTypes =
        trip.legs.map((leg) => leg.transportType).toSet();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 6.0, // Horizontal space between children
          runSpacing: 6.0, // Vertical space between lines
          children: [
            // Generate vehicle type boxes
            for (var vehicleType in uniqueVehicleTypes)
              Wrap(
                children: [
                  JournalDetailBoxVehicle(vehicleType),
                ],
              ),
            // Add JournalDetailBox for purpose and donation
            if (trip.purpose != null && trip.purpose!.isNotEmpty)
              JournalDetailBox(trip.purpose.toString()),
            JournalDetailBoxDonation(trip.donationState),
            // Icon at the end
          ],
        ),
      ),
    );
  }
}
