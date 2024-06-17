import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/logging.dart';
import 'package:trekko_backend/controller/wrapper/data_wrapper.dart';
import 'package:trekko_backend/model/log/log_entry.dart';
import 'package:trekko_backend/model/log/log_level.dart';
import 'package:trekko_backend/model/tracking/analyzer/wrapper_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';
import 'package:trekko_frontend/components/constants/button_size.dart';
import 'package:trekko_frontend/components/pop_up_utils.dart';
import 'package:trekko_frontend/trekko_provider.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Trekko app = TrekkoProvider.of(context);
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: CupertinoSliverNavigationBar(
                largeTitle: const Text('Logs'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Button(
                      title: "Dump",
                      stretch: false,
                      size: ButtonSize.small,
                      onPressed: () async {
                        DataWrapper w =
                            await app.getWrapper(WrapperType.BLACK_HOLE)!.first;
                        Map<String, dynamic> jsonMap = w.save();
                        String json = jsonEncode(jsonMap);
                        await Clipboard.setData(ClipboardData(text: json));
                        PopUpUtils.showPopUp(context, "Success",
                            "Data has been copied to clipboard.");
                      },
                    ),
                    const SizedBox(width: 5.0),
                    CupertinoButton(
                      child: const HeroIcon(HeroIcons.trash),
                      onPressed: () async {
                        await Logging.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder(
          future: Logging.read(),
          builder: (BuildContext context,
              AsyncSnapshot<Stream<List<LogEntry>>> snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder(
                stream: snapshot.data,
                builder: (BuildContext context,
                    AsyncSnapshot<List<LogEntry>> snapshot) {
                  if (snapshot.hasData) {
                    return CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              LogEntry entry = snapshot.data![index];
                              return CupertinoListTile(
                                title: Wrap(children: [
                                  Text(
                                    entry.message,
                                    style: TextStyle(
                                        color: entry.level == LogLevel.error
                                            ? CupertinoColors.systemRed
                                            : entry.level == LogLevel.warning
                                                ? CupertinoColors.systemYellow
                                                : CupertinoColors.black),
                                  ),
                                ]),
                                subtitle: Text(entry.timestamp.toString()),
                                onTap: () async {
                                  // Show dialog with full log entry
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                            "[${entry.level}]: ${entry.message}"),
                                        content:
                                            Text(entry.timestamp.toString()),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            childCount: snapshot.data!.length,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
