part of 'motion_bloc.dart';

abstract class MotionEvent extends Equatable {
  const MotionEvent();

  @override
  List<Object> get props => [];
}

class NewCoordinatesEvent extends MotionEvent {
  double xCoordinate;
  double yCoordinate;
  int indexMarina;
  String statusGear;
  bool isBoatRunning;
  NewCoordinatesEvent(
      {required this.xCoordinate,
      required this.yCoordinate,
      required this.indexMarina,
      required this.statusGear,
      required this.isBoatRunning});
}

class IdleEvent extends MotionEvent {}
