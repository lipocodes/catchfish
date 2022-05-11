import 'package:bloc/bloc.dart';
import 'package:catchfish/features/gameBoard/domain/entities/weather_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/weather_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async {
      if (event is InitialEvent) {
        emit(InitialState());
      } else if (event is GetWeatherEvent) {
        WeatherUsecase weatherUsecase = WeatherUsecase();
        WeatherEntity weatherEntity = await weatherUsecase.getWeatherDetails(
            event.latitude, event.longitude);

        GetWeatherState getWeatherState =
            GetWeatherState(weatherDetails: weatherEntity.weatherDetails);

        emit(getWeatherState);
      }
    });
  }
}
