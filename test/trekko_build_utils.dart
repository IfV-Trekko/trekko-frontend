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
    // Directory tempDir = await getTemporaryDirectory();
    // return tempDir.path;
    return "/var/folders/w5/dyy6d97s3hv4p2fm596f2qh80000gn/T/";
  }

  @override
  Future<String> getApplicationSupportPath() async {
    // Directory tempDir = await getTemporaryDirectory();
    // return tempDir.path;
    return "/var/folders/w5/dyy6d97s3hv4p2fm596f2qh80000gn/T/";
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
