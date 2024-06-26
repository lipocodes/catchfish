import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/fishing/fishing_repository.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;

@GenerateMocks([])
void main() {
  setUp(() async {});
  tearDown(() {});
  group("Testing LocalDatasourcePrefs", () {
    di.init();
    test("testing getLevelPref()", () async {
      final res = await sl.get<LocalDatasourcePrefs>().getLevelPref();
      expectLater(res, const Right(1));
    });
    test("testing getPersonalShopPref()", () async {
      final res = await sl.get<LocalDatasourcePrefs>().getPersonalShopPref();
      //expectLater(res, const Right([]));
    });
    test("testing addFishPersonalShop()", () async {
      final res = await sl
          .get<LocalDatasourcePrefs>()
          .addFishPersonalShop("Fat Fish^^^100^^^1000^^^fat_fish");
      expectLater(res, const Right(true));
    });
    test("testing removeFishPersonalShop()", () async {
      final res = await sl
          .get<LocalDatasourcePrefs>()
          .removeFishPersonalShop("Fat Fish^^^100^^^1000^^^fat_fish");
      expectLater(res, const Right(true));
    });
  });
}
