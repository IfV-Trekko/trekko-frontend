import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/trip/trip.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_utils.dart';
import 'trekko_build_utils.dart';

//TODO: T4, T5, T6, T7,

void main() {
  Trekko? trekko;

  final Trip trip = Trip();

  setUp(() async {
    await TrekkoBuildUtils.init();
    trekko = await TestUtils.initTrekko();
  });

  tearDown(() async {
    if (trekko != null) await TestUtils.clearTrekko(trekko!);
  });

  testWidgets("EXAMPLE DESCRIPTION", (tester) async {
  });

}
