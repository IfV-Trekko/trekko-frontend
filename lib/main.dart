import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:trekko_backend/controller/builder/last_login_builder.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/controller/utils/logging.dart';
import 'package:trekko_frontend/screens/onboarding/login_app.dart';
import 'package:trekko_frontend/screens/trekko_app.dart';

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Logging.errorE(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Logging.errorE(error, stack);
    return false;
  };

  await initializeDateFormatting('de', null);
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    runTrekkoApp(await LastLoginBuilder().build());
  } catch (e) {
    runLoginApp();
  }
}

void runTrekkoApp(Trekko trekko) {
  runApp(TrekkoApp(trekko: trekko));
}

void runLoginApp() {
  runApp(LoginApp((trekko) => runTrekkoApp(trekko)));
}
