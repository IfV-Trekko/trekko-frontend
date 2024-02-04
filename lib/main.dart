import 'dart:io';

import 'package:app_backend/controller/builder/build_exception.dart';
import 'package:app_backend/controller/builder/last_login_builder.dart';
import 'package:app_backend/controller/builder/login_builder.dart';
import 'package:app_backend/controller/builder/login_result.dart';
import 'package:app_backend/controller/builder/registration_builder.dart';
import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/login/login_app.dart';
import 'package:app_frontend/screens/trekko_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('de', null);
  WidgetsFlutterBinding.ensureInitialized();

  // try {
  //   runTrekkoApp(await LastLoginBuilder().build());
  // } catch (e) {
  //   runLoginApp();
  // }
  runLoginApp();
}

void runTrekkoApp(Trekko trekko) {
  runApp(TrekkoApp(trekko: trekko));
}

void runLoginApp() {
  runApp(LoginApp((trekko) => runTrekkoApp(trekko)));
}

Future<Trekko> buildTrekko() async {
  late String ip;
  if (Platform.isAndroid) {
    ip = "10.0.2.2";
  } else {
    ip = "localhost";
  }
  try {
    return await LoginBuilder(
            "http://$ip:8080", "realAccount1@web.de", "1aA!hklj32r4hkjl324ra")
        .build();
  } catch (e) {
    if (e is BuildException) {
      if (e.reason == LoginResult.failedNoSuchUser) {
        try {
          return await RegistrationBuilder(
                  "http://$ip:8080",
                  "realAccount1@web.de",
                  "1aA!hklj32r4hkjl324ra",
                  "1aA!hklj32r4hkjl324ra",
                  "12345")
              .build();
        } catch (e) {
          print((e as BuildException).reason);
        }
      }
    }
    rethrow;
  }
}
