import 'package:catchfish/core/errors/failures.dart';
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
  });
}
