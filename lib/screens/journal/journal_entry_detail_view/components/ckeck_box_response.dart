import 'package:app_backend/model/trip/transport_type.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class CheckBoxResponse<T> extends StatefulWidget {
  //TODO Name ändern
  final String title;
  final Function(List<TransportType>) onSaved;
  final List<TransportType> initialResponses;
  final List<TransportType> responses;
  final String Function(TransportType) getName;

  const CheckBoxResponse(
      {required this.responses,
      required this.title,
      required this.onSaved,
      required this.initialResponses,
      required this.getName,
      super.key});

  @override
  State<CheckBoxResponse<T>> createState() => _CheckBoxResponseState<T>();
}

class _CheckBoxResponseState<T> extends State<CheckBoxResponse<T>> {
  late List<TransportType> _newResponses;

  @override
  void initState() {
    super.initState();
    _newResponses = List.from(widget.initialResponses);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Transform.translate(
            offset: const Offset(-16, 0),
            child: CupertinoNavigationBarBackButton(
              previousPageTitle: 'Zurück',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          middle: Text(widget.title),
          trailing: Button(
            title: 'Speichern',
            size: ButtonSize.small,
            stretch: false,
            onPressed: () {
              widget.onSaved(_newResponses);
              Navigator.of(context).pop();
            },
          ),
        ),
        child: SafeArea(
          child: CupertinoListSection.insetGrouped(
            additionalDividerMargin: 2,
            children: [
              for (TransportType response in widget.responses)
                CupertinoListTile(
                  title: Text(widget.getName(response)),
                  trailing: (_newResponses.indexOf(response) == 1)
                      ? const HeroIcon(HeroIcons.check)
                      : const Text(''),
                  onTap: () {
                    (_newResponses.indexOf(response) == 1)
                        ? _newResponses.remove(response)
                        : _newResponses.add(response); //TODO funktioniert nicht
                  },
                )
            ],
          ),
        ));
  }
}
