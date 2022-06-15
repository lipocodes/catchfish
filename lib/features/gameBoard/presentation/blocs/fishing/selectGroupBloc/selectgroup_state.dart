part of 'selectgroup_bloc.dart';

abstract class SelectgroupState extends Equatable {
  const SelectgroupState();

  @override
  List<Object> get props => [];
}

class SelectgroupInitial extends SelectgroupState {}

class NeutralState extends SelectgroupState {
  final int selectedGroupType;
  const NeutralState({required this.selectedGroupType});
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
