part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class InitialState extends WeatherState {}

class GetWeatherState extends WeatherState {
  final String weatherDetails;
  const GetWeatherState({required this.weatherDetails});
}
