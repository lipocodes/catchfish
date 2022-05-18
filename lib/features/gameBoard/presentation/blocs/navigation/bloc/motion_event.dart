part of 'motion_bloc.dart';

abstract class MotionEvent extends Equatable {
  const MotionEvent();

  @override
  List<Object> get props => [];
}

class NewCoordinatesEvent extends MotionEvent {
  const NewCoordinatesEvent();
}

class IdleEvent extends MotionEvent {}
