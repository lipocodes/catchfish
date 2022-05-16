import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  double steeringAngle = 0.0;
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationEvent>((event, emit) {
      if (event is EnteringNavigationEvent) {
        emit(EnteringNavigationState());
      } else if (event is ShowMapEvent) {
        emit(ShowMapState());
      } else if (event is LeavingNavigationEvent) {
        emit(LeavingNavigationState());
      } else if (event is SpinSteeringWheelEvent) {
        if (event.isClockwise) {
          steeringAngle += 1.0;
        } else {
          steeringAngle -= 1.0;
        }
        emit(SpinSteeringWheelState(steeringAngle: steeringAngle));
      }
    });
  }
}
