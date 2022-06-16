part of 'selectgroup_bloc.dart';

abstract class SelectgroupState extends Equatable {
  const SelectgroupState();

  @override
  List<Object> get props => [];
}

class SelectgroupInitial extends SelectgroupState {}

class NeutralState extends SelectgroupState {
  final String selectedGroup;
  final int selectedGroupType;
  const NeutralState(
      {required this.selectedGroup, required this.selectedGroupType});
}

class AllowedStartGame extends SelectgroupState {
  final int selectedGroupType;
  const AllowedStartGame({required this.selectedGroupType});
}

class NotAllowedStartGame extends SelectgroupState {
  final int selectedGroupType;
  const NotAllowedStartGame({required this.selectedGroupType});
}

class SelectedGroupTypeState extends SelectgroupState {
  final int selectedGroupType;
  const SelectedGroupTypeState({required this.selectedGroupType});
}

class GroupNameValueState extends SelectgroupState {
  final String groupName;
  final int selectedGroupType;
  const GroupNameValueState(
      {required this.groupName, required this.selectedGroupType});
}

class YourNameValueState extends SelectgroupState {
  final String yourName;
  final int selectedGroupType;
  const YourNameValueState(
      {required this.yourName, required this.selectedGroupType});
}

class SelectedGroupState extends SelectgroupState {
  final String selectedGroup;
  final int selectedGroupType;

  const SelectedGroupState(
      {required this.selectedGroup, required this.selectedGroupType});
}
