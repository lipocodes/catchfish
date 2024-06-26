part of 'introduction_bloc.dart';

abstract class IntroductionState extends Equatable {
  const IntroductionState();

  @override
  List<Object> get props => [];
}

class IntroductionInitial extends IntroductionState {}

class LoadingState extends IntroductionState {
  final String name;
  const LoadingState({required this.name});
}

class TimerTickState extends IntroductionState {}

class IntroductionEnd extends IntroductionState {}
