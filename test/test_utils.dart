import 'package:app_backend/controller/profiled_trekko.dart';
import 'package:app_backend/controller/request/bodies/request/auth_request.dart';
import 'package:app_backend/controller/request/bodies/response/auth_response.dart';
import 'package:app_backend/controller/request/url_trekko_server.dart';
import 'package:app_backend/controller/trekko.dart';

class TestUtils {
  static Future<Trekko> makeTrekko(
      String projectUrl, String email, String token) async {
    Trekko trekko =
    ProfiledTrekko(projectUrl: projectUrl, email: email, token: token);
    await trekko.init();
    return trekko;
  }

  static Future<Trekko> initTrekko() async {
    final UrlTrekkoServer trekkoServer = UrlTrekkoServer('http://localhost:8080');

    String uniqueEmail = 'test@example.com';
    AuthResponse authResponse;

    try {
      authResponse = await trekkoServer.signUp(AuthRequest(uniqueEmail, '!Abc123#'));
    } catch (e) {
      authResponse = await trekkoServer.signIn(AuthRequest(uniqueEmail, '!Abc123#'));
    }
    return await makeTrekko('http://localhost:8080', uniqueEmail, authResponse.token);
  }

  static Future<void> clearTrekko(Trekko trekko) async {
    await trekko.signOut(delete: true);
  }
}