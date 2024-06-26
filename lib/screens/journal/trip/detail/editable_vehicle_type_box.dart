import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/model/trip/transport_type.dart';
import 'package:trekko_frontend/components/tile_utils.dart';
import 'package:trekko_frontend/components/constants/transport_design.dart';
import 'package:trekko_frontend/components/responses/select_view.dart';
import 'package:trekko_frontend/screens/journal/entry/components/vehicle_box.dart';

class EditableVehicleTypeBox extends StatelessWidget {

  final TransportType type;
  final Function(TransportType) onSavedVehicle;

  const EditableVehicleTypeBox(
      {super.key, required this.type, required this.onSavedVehicle});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      padding: TileUtils.listTilePadding,
      title: TileUtils.buildTitleRow('Verkehrsmittel', HeroIcons.bolt),
      trailing: const CupertinoListTileChevron(),
      additionalInfo: VehicleBox(type, showText: false),
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => SelectView<TransportType>(
                  singleSelect: true,
                  getName: TransportDesign.getName,
                  title: 'Verkehrsmittel',
                  responses: TransportType.values,
                  onSaved: (List<TransportType> value) =>
                      onSavedVehicle(value.first),
                  initialResponses: [type],
                )));
      },
    );
  }
}
