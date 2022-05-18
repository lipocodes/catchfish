import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'motion_event.dart';
part 'motion_state.dart';

class MotionBloc extends Bloc<MotionEvent, MotionState> {
  double xCoordinate = 32.80551;
  double yCoordinate = 35.03183;
  MotionBloc() : super(MotionInitial()) {
    on<MotionEvent>((event, emit) {
      if (event is NewCoordinatesEvent) {
        xCoordinate += 0.001;
        yCoordinate += 0.001;
        emit(NewCoordinatesState(
            xCoordinate: xCoordinate, yCoordinate: yCoordinate));
      } else if (event is IdleEvent) {
        emit(IdleState());
      }
    });
  }
}
