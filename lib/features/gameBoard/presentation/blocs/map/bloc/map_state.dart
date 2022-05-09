part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class ChooseRandomLocationState extends MapState {
  final String marinaName;
  final Marker origin;
  final Marker destination;
  final CameraPosition initialCameraPosition;
  const ChooseRandomLocationState(
      {required this.marinaName,
      required this.origin,
      required this.destination,
      required this.initialCameraPosition});
}

class SwitchLocationState extends MapState {}
