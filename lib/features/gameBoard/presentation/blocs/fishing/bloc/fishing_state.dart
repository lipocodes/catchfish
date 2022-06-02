part of 'fishing_bloc.dart';

abstract class FishingState extends Equatable {
  const FishingState();

  @override
  List<Object> get props => [];
}

class FishingInitial extends FishingState {}

class GetPulseState extends FishingState {
  final double pulseStrength;
  final double pulseLength;
  const GetPulseState({required this.pulseStrength, required this.pulseLength});
}

class ErrorGetPulseState extends FishingState {
  final String message;
  const ErrorGetPulseState({required this.message});
}
