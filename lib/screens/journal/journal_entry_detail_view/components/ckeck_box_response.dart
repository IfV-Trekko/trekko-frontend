import 'package:app_frontend/components/button.dart';
import 'package:app_frontend/components/constants/button_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class CheckBoxResponse extends StatefulWidget {
  const CheckBoxResponse({super.key});

  @override
  State<CheckBoxResponse> createState() => _CheckBoxResponseState();
}

class _CheckBoxResponseState extends State<CheckBoxResponse> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        //TODO auslagern?
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            previousPageTitle: 'Zurück',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          middle: const Text('Verkehrsmittel'),
          trailing: Button(
            title: 'Speichern',
            size: ButtonSize.small,
            stretch: false,
            onPressed: () {
              //TODO Implement
              Navigator.of(context).pop();
            },
          ),
        ),
        child: SafeArea(
          child: CupertinoListSection(
            additionalDividerMargin: 2,
            children: const [
              CupertinoListTile(
                title: Text('Auto'),
                trailing: HeroIcon(HeroIcons.check),
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
