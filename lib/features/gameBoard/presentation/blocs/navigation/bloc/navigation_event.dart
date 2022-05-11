part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class EnteringNavigationEvent implements NavigationEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class ShowMapEvent implements NavigationEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class LeavingNavigationEvent implements NavigationEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
