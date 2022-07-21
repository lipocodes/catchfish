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
  final String statusGear;
  final double steeringAngle;
  const ShowMapState(
      {required this.isBoatRunning,
      required this.statusGear,
      required this.steeringAngle});
}

class LeavingNavigationState extends NavigationState {}

class SpinSteeringWheelState extends NavigationState {
  final double steeringAngle;
  final bool isBoatRunning;
  final String statusGear;
  const SpinSteeringWheelState(
      {required this.steeringAngle,
      required this.isBoatRunning,
      required this.statusGear});
}

class IgnitionState extends NavigationState {
  final bool isBoatRunning;
  final String statusGear;
  final double steeringAngle;
  const IgnitionState(
      {required this.isBoatRunning,
      required this.statusGear,
      required this.steeringAngle});
}

class GearState extends NavigationState {
  final bool isBoatRunning;
  final String statusGear;
  final double steeringAngle;
  const GearState(
      {required this.isBoatRunning,
      required this.statusGear,
      required this.steeringAngle});
}
