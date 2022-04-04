import 'package:bloc/bloc.dart';
import 'package:catchfish/features/introduction/domain/entities/introduction_settings.dart';
import 'package:equatable/equatable.dart';

part 'introduction_event.dart';
part 'introduction_state.dart';

class IntroductionBloc extends Bloc<IntroductionEvent, IntroductionState> {
  IntroductionBloc() : super(IntroductionInitial()) {
    on<IntroductionEvent>((event, emit) {
      if (event is LoadingEvent) {
        emit(const LoadingState(name: "LoadingEvent"));
      } else if (event is TimerTickEvent) {
        emit(TimerTickState());
      }
    });
  }
}
