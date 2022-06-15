import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'selectgroup_event.dart';
part 'selectgroup_state.dart';

class SelectgroupBloc extends Bloc<SelectgroupEvent, SelectgroupState> {
  int _selectedGroupType = 0;
  String _groupName = "";
  String _yourName = "";

  SelectgroupBloc() : super(SelectgroupInitial()) {
    on<SelectgroupEvent>((event, emit) {
      if (event is NeutralEvent) {
        emit(NeutralState(selectedGroupType: _selectedGroupType));
      } else if (event is PressStartGameButtonEvent) {
        if (_selectedGroupType == 0) {
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
      }
    });
  }
}
