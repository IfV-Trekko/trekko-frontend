import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class MultiSelectResponse<T> extends StatefulWidget {
  final bool singleSelect;
  final String title;
  final Function(List<T>) onSaved;
  final List<T> initialResponses;
  final List<T> responses;
  final String Function(T) getName;

  const MultiSelectResponse(
      {required this.responses,
      required this.singleSelect,
      required this.title,
      required this.onSaved,
      required this.initialResponses,
      required this.getName,
      super.key});

  @override
  State<MultiSelectResponse<T>> createState() => _MultiSelectResponseState<T>();
}

class _MultiSelectResponseState<T> extends State<MultiSelectResponse<T>> {
  late List<T> _newResponses;

  @override
  void initState() {
    super.initState();
    _newResponses = List.from(widget.initialResponses);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: AppThemeColors.contrast100,
          border: const Border.fromBorderSide(BorderSide.none),
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
            backgroundColor: AppThemeColors.contrast100,
            additionalDividerMargin: 2,
            children: [
              for (T response in widget.responses)
                CupertinoListTile(
                  title: Text(widget.getName(response)),
                  trailing: (_newResponses.contains(response))
                      ? const HeroIcon(HeroIcons.check)
                      : const Text(''),
                  onTap: widget.singleSelect
                      ? () {
                          setState(() {
                            if (_newResponses.contains(response)) {
                            } else {
                              _newResponses.clear();
                              _newResponses.add(response);
                            }
                          });
                        }
                      : () {
                          setState(() {
                            if (_newResponses.contains(response)) {
                              _newResponses.remove(response);
                            } else {
                              _newResponses.add(response);
                            }
                          });
                        },
                )
            ],
          ),
        ));
  }
}
