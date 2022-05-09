part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class ChooseRandomLocationEvent implements MapEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class SwitchLocationEvent implements MapEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
