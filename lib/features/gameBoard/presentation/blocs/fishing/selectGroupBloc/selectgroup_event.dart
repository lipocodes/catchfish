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
