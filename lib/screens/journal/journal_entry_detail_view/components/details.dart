import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class Details extends StatefulWidget {
  final String detailPurpose;
  final String detailComment;
  final Function(String) onSavedPurpose;
  final Function(String) onSavedComment;

  const Details(
      {required this.detailPurpose,
      required this.onSavedPurpose,
      required this.detailComment,
      required this.onSavedComment,
      super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      CupertinoListSection.insetGrouped(
        backgroundColor: AppThemeColors.contrast150,
        additionalDividerMargin: 2,
        children: [
          CupertinoListTile(
            title: Text('Anlass / Zweck', style: AppThemeTextStyles.normal),
            trailing: Container(child: CupertinoListTileChevron()),
            additionalInfo: widget.detailPurpose.isEmpty
                ? Container(child: Text('Arbeit, Freizeit, etc.'))
                : Container(
                    child: Text(
                      widget.detailPurpose,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                    width: 150,
                  ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                      maxLength: 350,
                      onSaved: widget.onSavedPurpose,
                      title: 'Anlass / Zweck',
                      placeholder: 'Arbeit, Freizeit, etc.',
                      initialValue: widget.detailPurpose)));
            },
          ),
          CupertinoListTile(
            title: Text('Verkehrsmittel', style: AppThemeTextStyles.normal),
            trailing: Container(child: CupertinoListTileChevron()),
            additionalInfo:
                Container(child: Text('zu Fuß')), //TODO implementieren
            onTap: () {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => CheckBoxResponse()));
            },
          ),
        ],
      ),
      CupertinoListSection.insetGrouped(
        //TODO Bei Zeilenumbruch richtig angezeigt?
        //TODO auslagern
        backgroundColor: AppThemeColors.contrast150,
        children: [
          CupertinoListTile(
            title: Text('Kommentar', style: AppThemeTextStyles.normal),
            trailing: Container(child: CupertinoListTileChevron()),
            additionalInfo: widget.detailComment.isEmpty
                ? Container(child: Text('Anmerkung, Fehler, etc.'))
                : Container(
                    child: Text(
                      widget.detailComment,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                    width: 150,
                  ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                      maxLength: 700,
                      onSaved: widget.onSavedComment,
                      title: 'Kommentar',
                      placeholder: 'Anmerkung, Fehler, etc.',
                      initialValue: widget.detailComment)));
            },
          ),
        ],
      ),
    ]));
  }
}

class TextResponse extends StatefulWidget {
  //TODO auslagern
  final int maxLength;
  final String title;
  final String initialValue;
  final String placeholder;
  final Function(String) onSaved;
  late TextEditingController _controller;

  TextResponse(
      {super.key,
      required this.maxLength,
      required this.onSaved,
      required this.title,
      required this.placeholder,
      required this.initialValue}) {
    _controller = TextEditingController(text: initialValue);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }
  @override
  State<TextResponse> createState() => _TextResponseState();
}

class _TextResponseState extends State<TextResponse> {
  late String _newResponse;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Zurück',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Text(widget.title),
        trailing: Button(
          title: 'Speichern',
          size: ButtonSize.small,
          stretch: false,
          onPressed: () {
            widget.onSaved(_newResponse);
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: CupertinoTextField(
            controller: widget._controller,
            scrollPadding: const EdgeInsets.all(2),
            maxLength: widget.maxLength,
            maxLines: null,
            placeholder: widget.placeholder,
            autofocus: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onChanged: (String value) {
              setState(() {
                _newResponse = value;
              });
            },
          ),
        ),
      ),
    );
  }
}

class CheckBoxResponse extends StatefulWidget {
  const CheckBoxResponse();

  @override
  State<CheckBoxResponse> createState() => _CheckBoxResponseState();
}

class _CheckBoxResponseState extends State<CheckBoxResponse> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            previousPageTitle: 'Zurück',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          middle: Text('Verkehrsmittel'),
          trailing: Button(
            title: 'Speichern',
            size: ButtonSize.small,
            stretch: false,
            onPressed: () {
              //TODO Implement und auslagern
              Navigator.of(context).pop();
            },
          ),
        ),
        child: SafeArea(
          child: CupertinoListSection(
            additionalDividerMargin: 2,
            children: [
              CupertinoListTile(
                title: Text('Auto'),
                trailing: Container(child: HeroIcon(HeroIcons.check)),
              ),
              CupertinoListTile(
                title: Text('Fahrrad'),
              ),
              CupertinoListTile(
                title: Text('ÖPNV'),
              ),
              CupertinoListTile(
                title: Text('Boot'),
              ),
              CupertinoListTile(
                title: Text('Zu Fuß'),
              ),
            ], //TODO Implementieren
          ),
        ));
  }
}
