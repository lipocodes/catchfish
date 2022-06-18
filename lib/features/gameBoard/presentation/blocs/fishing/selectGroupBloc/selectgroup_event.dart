part of 'selectgroup_bloc.dart';

abstract class SelectgroupEvent extends Equatable {
  const SelectgroupEvent();

  @override
  List<Object> get props => [];
}

class NeutralEvent extends SelectgroupEvent {}

class PressStartGameButtonEvent implements SelectgroupEvent {
  @override
  List<Object> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

class PressButtonGroupTypeEvent extends SelectgroupEvent {
  final int selectedGroupType;
  const PressButtonGroupTypeEvent({required this.selectedGroupType});
}

class GroupNameChangedEvent extends SelectgroupEvent {
  final String groupName;
  const GroupNameChangedEvent({required this.groupName});
}

class YourNameChangedEvent extends SelectgroupEvent {
  final String yourName;
  final String selectedGroup;
  const YourNameChangedEvent(
      {required this.yourName, required this.selectedGroup});
}

class SelectedExistingGroupEvent extends SelectgroupEvent {
  final String selectedGroup;
  const SelectedExistingGroupEvent({required this.selectedGroup});
}

class EnteringScreenEvent extends SelectgroupEvent {
  final SelectGroupUsecase selectGroupUsecase;
  const EnteringScreenEvent({required this.selectGroupUsecase});
}
