part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends WeatherEvent {}

class GetWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;
  const GetWeatherEvent({required this.latitude, required this.longitude});
}
