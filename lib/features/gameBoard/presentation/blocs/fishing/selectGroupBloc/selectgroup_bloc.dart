import 'package:bloc/bloc.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/injection_container.dart';
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
        if (_selectedGroupType == 0 && _yourName.isEmpty) {
          emit(NotAllowedStartGame(selectedGroupType: _selectedGroupType));
        } else {
          //if user selects to join a group
          SelectGroupRepositoryImpl selectGroupRepositoryImpl =
              SelectGroupRepositoryImpl();
          if (_selectedGroupType == 0) {
            _groupName = "solo_" + _yourName;
          }
          if (_selectedGroupType == 0) {
            final res = await sl.get<SelectGroupUsecase>().createNewGroup(
                _groupName, _yourName, selectGroupRepositoryImpl);

            if (res.isRight()) {
              emit(AllowedStartGame(selectedGroupType: _selectedGroupType));
            } else {
              emit(NotAllowedStartGame(selectedGroupType: _selectedGroupType));
            }
          }
        }
      } else if (event is PressButtonGroupTypeEvent) {
        if (_yourName.isEmpty) {
          emit(const SelectedGroupTypeState(selectedGroupType: 0));
          return;
        }
        _selectedGroupType = event.selectedGroupType;
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt("selectedGroupType", _selectedGroupType);

        emit(SelectedGroupTypeState(selectedGroupType: _selectedGroupType));
      } else if (event is GroupNameChangedEvent) {
        _groupName = event.groupName;
      } else if (event is YourNameChangedEvent) {
        _yourName = event.yourName;

        if (_yourName.isEmpty) {
          emit(const SelectedGroupTypeState(selectedGroupType: 0));
          emit(const NeutralState(selectedGroup: "", selectedGroupType: 0));
          return;
        }
      } else if (event is SelectedExistingGroupEvent) {
        _selectedGroup = event.selectedGroup;

        emit(SelectedGroupState(
          selectedGroupType: _selectedGroupType,
          selectedGroup: _selectedGroup,
        ));
      } else if (event is LeavingScreenEvent) {
        emit(const NotAllowedStartGame(selectedGroupType: 0));
      }
    });
  }
}
