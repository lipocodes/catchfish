part of 'motion_bloc.dart';

abstract class MotionEvent extends Equatable {
  const MotionEvent();

  @override
  List<Object> get props => [];
}

class NewCoordinatesEvent extends MotionEvent {
  double xCoordinate;
  double yCoordinate;
  NewCoordinatesEvent({required this.xCoordinate, required this.yCoordinate});
}

class IdleEvent extends MotionEvent {}
