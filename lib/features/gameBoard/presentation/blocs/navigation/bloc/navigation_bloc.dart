import 'package:bloc/bloc.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  double steeringAngle = 0.0;
  bool isBoatRunning = false;
  PlaySound playSound = PlaySound();
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationEvent>((event, emit) {
      if (event is EnteringNavigationEvent) {
        emit(EnteringNavigationState());
      } else if (event is ShowMapEvent) {
        emit(ShowMapState(isBoatRunning: isBoatRunning));
      } else if (event is LeavingNavigationEvent) {
        emit(LeavingNavigationState());
      } else if (event is SpinSteeringWheelEvent) {
        if (event.isClockwise) {
          steeringAngle += 0.04;
        } else {
          steeringAngle -= 0.04;
        }
        emit(SpinSteeringWheelState(
            steeringAngle: steeringAngle, isBoatRunning: isBoatRunning));
      } else if (event is IgnitionEvent) {
        if (isBoatRunning) {
          print("aaaaaaaaaaaaaaaaaaaaaa");
          isBoatRunning = false;
          playSound.stop();
          emit(const IgnitionState(isBoatRunning: false));
        } else {
          print("bbbbbbbbbbbbbbbbbbbbbb");
          isBoatRunning = true;
          for (int a = 0; a < 3; a++) {
            playSound.play(
                path: "assets/sounds/gameBoard/", fileName: "ignition1.mp3");
            playSound.stop();
          }
        }
        emit(const IgnitionState(isBoatRunning: true));
      }
    });
  }
}
