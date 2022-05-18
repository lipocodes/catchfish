import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'motion_event.dart';
part 'motion_state.dart';

class MotionBloc extends Bloc<MotionEvent, MotionState> {
  MotionBloc() : super(MotionInitial()) {
    on<MotionEvent>((event, emit) {
      if (event is NewCoordinatesEvent) {
        event.xCoordinate += 0.0001;
        event.yCoordinate += 0.0001;
        emit(NewCoordinatesState(
            xCoordinate: event.xCoordinate, yCoordinate: event.yCoordinate));
      } else if (event is IdleEvent) {
        emit(IdleState());
      }
    });
  }
}
