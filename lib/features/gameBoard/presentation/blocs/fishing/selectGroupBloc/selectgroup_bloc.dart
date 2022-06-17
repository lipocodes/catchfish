import 'package:bloc/bloc.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:equatable/equatable.dart';

part 'selectgroup_event.dart';
part 'selectgroup_state.dart';

class SelectgroupBloc extends Bloc<SelectgroupEvent, SelectgroupState> {
  int _selectedGroupType = 0;
  String _groupName = "";
  String _yourName = "";
  String _selectedGroup = "";

  SelectgroupBloc() : super(SelectgroupInitial()) {
    on<SelectgroupEvent>((event, emit) async {
      if (event is NeutralEvent) {
        emit(NeutralState(
            selectedGroup: _selectedGroup,
            selectedGroupType: _selectedGroupType));
      } else if (event is EnteringScreenEvent) {
        SelectGroupRepositoryImpl selectGroupRepositoryImpl =
            SelectGroupRepositoryImpl();
        var res = await event.selectGroupUsecase
            .retreiveListGroups(selectGroupRepositoryImpl);
        ListGroupEntity l = ListGroupEntity(list: []);
        res.fold(
          (failure) => null,
          (success) => l.list = success.list,
        );
        emit(EnteringScreenState(
            listGroups: l.list, selectedGroup: _selectedGroup));
      } else if (event is PressStartGameButtonEvent) {
        if (_selectedGroupType == 0 ||
            (_selectedGroupType == 1 &&
                (_groupName.isEmpty || _yourName.isEmpty)) ||
            (_selectedGroupType == 2 && _selectedGroup.isEmpty)) {
          emit(NotAllowedStartGame(selectedGroupType: _selectedGroupType));
        } else {
          emit(AllowedStartGame(selectedGroupType: _selectedGroupType));
        }
      } else if (event is PressButtonGroupTypeEvent) {
        _selectedGroupType = event.selectedGroupType;

        emit(SelectedGroupTypeState(selectedGroupType: _selectedGroupType));
      } else if (event is GroupNameChangedEvent) {
        _groupName = event.groupName;

        emit(GroupNameValueState(
            groupName: _groupName, selectedGroupType: _selectedGroupType));
      } else if (event is YourNameChangedEvent) {
        _yourName = event.yourName;
        emit(YourNameValueState(
            yourName: _yourName, selectedGroupType: _selectedGroupType));
      } else if (event is SelectedExistingGroupEvent) {
        _selectedGroup = event.selectedGroup;

        _groupName = "";
        _yourName = "";
        emit(SelectedGroupState(
          selectedGroupType: _selectedGroupType,
          selectedGroup: _selectedGroup,
        ));
      }
    });
  }
}
