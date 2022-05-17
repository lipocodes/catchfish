part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class EnteringNavigationState extends NavigationState {}

class ShowMapState extends NavigationState {
  final bool isBoatRunning;
  const ShowMapState({required this.isBoatRunning});
}

class LeavingNavigationState extends NavigationState {}

class SpinSteeringWheelState extends NavigationState {
  final double steeringAngle;
  final bool isBoatRunning;
  const SpinSteeringWheelState(
      {required this.steeringAngle, required this.isBoatRunning});
}

class IgnitionState extends NavigationState {
  final bool isBoatRunning;
  const IgnitionState({required this.isBoatRunning});
}
