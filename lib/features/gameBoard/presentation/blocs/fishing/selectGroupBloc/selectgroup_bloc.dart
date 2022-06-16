import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'selectgroup_event.dart';
part 'selectgroup_state.dart';

class SelectgroupBloc extends Bloc<SelectgroupEvent, SelectgroupState> {
  int _selectedGroupType = 0;
  String _groupName = "";
  String _yourName = "";
  String _selectedGroup = "";

  SelectgroupBloc() : super(SelectgroupInitial()) {
    print("aaaaaaaaaaaaaaaaaaa=" + state.toString());
    on<SelectgroupEvent>((event, emit) {
      if (event is NeutralEvent) {
        emit(NeutralState(
            selectedGroup: _selectedGroup,
            selectedGroupType: _selectedGroupType));
      } else if (event is PressStartGameButtonEvent) {
        if (_selectedGroupType == 0 ||
            (_selectedGroupType == 1 &&
                (_groupName.isEmpty || _yourName.isEmpty))) {
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
