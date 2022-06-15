part of 'selectgroup_bloc.dart';

abstract class SelectgroupEvent extends Equatable {
  const SelectgroupEvent();

  @override
  List<Object> get props => [];
}

class PressStartGameButtonEvent implements SelectgroupEvent {
  @override
  List<Object> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}
