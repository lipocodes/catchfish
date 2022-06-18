import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/selector_group_type.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'selectGroup_usecase_test.mocks.dart';

@GenerateMocks([SelectGroupRepositoryImpl])
void main() {
  MockSelectGroupRepositoryImpl mockSelectGroupRepositoryImpl =
      MockSelectGroupRepositoryImpl();
  SelectGroupUsecase selectGroupUsecase = SelectGroupUsecase();
  setUp(() async {});
  tearDown(() {});

  group("Testing SelectGroupUsecase", () {
    di.init();

    test('testing retreiveListGroups()', () async {
      List<String> listGroups = [
        "Group1",
        "Group2",
        "Group3",
        "Group4",
        "Group5",
        "Group6",
        "Group7"
      ];
      RemoteDatasource remoteDatasource = RemoteDatasource();
      when(mockSelectGroupRepositoryImpl.retreiveListGroups(remoteDatasource))
          .thenAnswer((_) async => Right(ListGroupModel(list: listGroups)));
      final res = await selectGroupUsecase
          .retreiveListGroups(mockSelectGroupRepositoryImpl);

      //expectLater(res, Right(ListGroupModel(list: listGroups)));
    });
    test('testing addUserToGroup()', () async {
      RemoteDatasource remoteDatasource = RemoteDatasource();
      when(mockSelectGroupRepositoryImpl.addUserToGroup(
              "Group1", "Lior", remoteDatasource))
          .thenAnswer((realInvocation) async => const Right(true));
      final res = await selectGroupUsecase.addUserToGroup(
          "Group1", "Lior", mockSelectGroupRepositoryImpl);
      expectLater(res, const Right(true));
    });
  });
}
