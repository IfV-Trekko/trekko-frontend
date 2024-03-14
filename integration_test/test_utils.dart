import 'package:app_backend/controller/profiled_trekko.dart';
import 'package:app_backend/controller/request/bodies/request/auth_request.dart';
import 'package:app_backend/controller/request/bodies/response/auth_response.dart';
import 'package:app_backend/controller/request/url_trekko_server.dart';
import 'package:app_backend/controller/trekko.dart';

import 'dart:io';

import 'package:app_backend/controller/utils/tracking_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:background_locator_2/background_locator.dart';

class MyHttpOverrides extends HttpOverrides {}

class MockPathProvider extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  @override
  Future<String> getApplicationSupportPath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }
}

class TrekkoBuildUtils {
  @GenerateMocks([BackgroundLocator])
  static Future<void> init() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    await Isar.initializeIsarCore(download: true);
    PathProviderPlatform.instance = MockPathProvider();
    LocationBackgroundTracking.debug = true;
  }
}

class TestUtils {
  static String getAddress() {
    String ip = "localhost";
    if (Platform.isAndroid) {
      ip = "10.0.2.2";
    } else if (Platform.isMacOS) {
      ip =  "127.0.0.1";
    } else {
      ip =  "localhost";
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

  static Future<Trekko> initTrekko() async {
    final UrlTrekkoServer trekkoServer = UrlTrekkoServer(getAddress());

    String uniqueEmail = 'test@example.com';
    AuthResponse authResponse;

    try {
      authResponse = await trekkoServer.signUp(AuthRequest(uniqueEmail, '!Abc123#'));
    } catch (e) {
      authResponse = await trekkoServer.signIn(AuthRequest(uniqueEmail, '!Abc123#'));
    }
    return await makeTrekko(getAddress(), uniqueEmail, authResponse.token);
  }

  static Future<void> clearTrekko(Trekko trekko) async {
    await trekko.signOut(delete: true);
  }
}