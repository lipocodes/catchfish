part of 'fishing_bloc.dart';

abstract class FishingEvent extends Equatable {
  const FishingEvent();

  @override
  List<Object> get props => [];
}

class GetPulseEvent extends FishingEvent {
  const GetPulseEvent();
}
