import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'select_group_bloc_test.mocks.dart';

@GenerateMocks([SelectGroupUsecase])
void main() {
  late MockSelectGroupUsecase mockSelectGroupUsecase;
  late SelectgroupBloc selectGroupBloc;
  tearDown(() {});
  group("Testing BLOC SelectGroupBloc", () {
    di.init();
    mockSelectGroupUsecase = MockSelectGroupUsecase();
    selectGroupBloc = sl.get<SelectgroupBloc>();

    mockSelectGroupUsecase = MockSelectGroupUsecase();
    test('testing retreiveListGroups()', () {
      /* List<String> listGroups = [
        "Group1",
        "Group2",
        "Group3",
        "Group4",
        "Group5",
        "Group6",
        "Group7"
      ];
      SelectGroupRepositoryImpl selectGroupRepositoryImpl =
          SelectGroupRepositoryImpl();
      when(mockSelectGroupUsecase.retreiveListGroups())
          .thenAnswer((_) async => Right(ListGroupEntity(list: listGroups)));
      selectGroupBloc
          .add(EnteringScreenEvent(selectGroupUsecase: mockSelectGroupUsecase));
      expectLater(
          selectGroupBloc.stream,
          emitsInAnyOrder([
            EnteringScreenState(listGroups: listGroups, selectedGroup: "")
          ]));*/
    });
    test('testing retreiveListGroups()', () {
      when(mockSelectGroupUsecase.addUserToGroup("Group1", "Lior"))
          .thenAnswer((_) async => const Right(true));

      selectGroupBloc.add(const YourNameChangedEvent(
          yourName: "Lior", selectedGroup: "Group1"));
      selectGroupBloc.add(const GroupNameChangedEvent(groupName: "Group1"));
      selectGroupBloc
          .add(const PressButtonGroupTypeEvent(selectedGroupType: 2));
      selectGroupBloc.add(PressStartGameButtonEvent());
      expectLater(
          selectGroupBloc.stream,
          emitsAnyOf([
            const YourNameValueState(yourName: "Lior", selectedGroupType: 2),
            const GroupNameValueState(
                groupName: "Group1", selectedGroupType: 2),
            const SelectedGroupTypeState(selectedGroupType: 2),
            const NotAllowedStartGame(selectedGroupType: 2),
          ]));
    });
  });
}
