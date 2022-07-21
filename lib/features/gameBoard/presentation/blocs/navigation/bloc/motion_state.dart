part of 'motion_bloc.dart';

abstract class MotionState extends Equatable {
  const MotionState();

  @override
  List<Object> get props => [];
}

class MotionInitial extends MotionState {}

class NewCoordinatesState extends MotionState {
  final double xCoordinate;
  final double yCoordinate;
  const NewCoordinatesState(
      {required this.xCoordinate, required this.yCoordinate});
}

class IdleState extends MotionState {}
