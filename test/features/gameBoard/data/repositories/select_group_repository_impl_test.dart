import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'fishing_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDatasource])
void main() {
  MockRemoteDatasource mockRemoteDatasource = MockRemoteDatasource();
  SelectGroupRepositoryImpl selectGroupRepositoryImpl =
      SelectGroupRepositoryImpl();

  setUp(() async {});
  tearDown(() {});

  group("Testing SelectGroupRepositoryImpl", () {
    di.init();

    test('testing retreiveListGroups()', () async {
      List<String> listGroups = [
        "Group1",
      ];
      when(mockRemoteDatasource.retreiveListGroups())
          .thenAnswer((_) async => Right(ListGroupModel(list: listGroups)));
      final res = await selectGroupRepositoryImpl
          .retreiveListGroups(mockRemoteDatasource);
      res.fold((failure) => GeneralFailure(),
          (success) => listGroups = success.list);

      expectLater(res, Right(ListGroupModel(list: listGroups)));
    });
    test("testing addUserToGroup()", () async {
      when(mockRemoteDatasource.addPlayerToGroup("Lior"))
          .thenAnswer((_) async => const Right(true));
      final res = await selectGroupRepositoryImpl.addUserToGroup(
          "Group1", "Lior", mockRemoteDatasource);
      if (res.isRight()) {
        expectLater(res, const Right(true));
      } else {
        expectLater(res, Left(GeneralFailure()));
      }
    });
    test("testing createNewGroup()", () async {
      LocalDatasourcePrefs localDatasourcePrefs = LocalDatasourcePrefs();
      when(mockRemoteDatasource.createNewGroup("Group1", "Lior"))
          .thenAnswer((_) async => const Right(true));
      final res = await selectGroupRepositoryImpl.createNewGroup(
          "Group1", "Lior", mockRemoteDatasource, localDatasourcePrefs);
      if (res.isRight()) {
        expectLater(res, const Right(true));
      } else {
        expectLater(res, Left(GeneralFailure()));
      }
    });
  });
}
