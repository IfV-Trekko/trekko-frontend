import 'package:intl/date_symbol_data_local.dart';
import 'package:trekko_backend/controller/profiled_trekko.dart';
import 'package:trekko_backend/controller/request/bodies/request/auth_request.dart';
import 'package:trekko_backend/controller/request/bodies/response/auth_response.dart';
import 'package:trekko_backend/controller/request/url_trekko_server.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:flutter/services.dart';

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:permission_handler/permission_handler.dart';

class TestUtils {
  static String getAddress() {
    String ip = "localhost";
    if (Platform.isAndroid) {
      ip = "10.0.2.2";
    } else if (Platform.isMacOS) {
      ip = "127.0.0.1";
    } else {
      ip = "localhost";
    }
    return "http://$ip:8080";
  }

  static Future<Trekko> makeTrekko(
      String projectUrl, String email, String token) async {
    Trekko trekko =
        ProfiledTrekko(projectUrl: projectUrl, email: email, token: token);
    await trekko.init();
    return trekko;
  }

  static Future<void> init() async {
    initializeDateFormatting();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('flutter.baseflow.com/permissions/methods'),
            (message) async => PermissionStatus.granted.index);
  }

  static Future<Trekko> initTrekko() async {
    await init();
    final UrlTrekkoServer trekkoServer = UrlTrekkoServer(getAddress());

    String uniqueEmail = 'test@example.com';
    AuthResponse authResponse;

    try {
      authResponse =
          await trekkoServer.signUp(AuthRequest(uniqueEmail, '!Abc123#'));
    } catch (e) {
      authResponse =
          await trekkoServer.signIn(AuthRequest(uniqueEmail, '!Abc123#'));
    }
    return await makeTrekko(getAddress(), uniqueEmail, authResponse.token);
  }

  static Future<void> clearTrekko(Trekko trekko) async {
    await trekko.signOut(delete: true);
  }
}
