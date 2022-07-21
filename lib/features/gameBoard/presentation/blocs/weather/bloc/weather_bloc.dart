import 'package:bloc/bloc.dart';
import 'package:catchfish/features/gameBoard/domain/entities/weather/weather_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/weather/weather_usecase.dart';
import 'package:equatable/equatable.dart';

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
        print("dddddddddddddddddddddd=" +
            weatherEntity.weatherDetails.toString());
        GetWeatherState getWeatherState =
            GetWeatherState(weatherDetails: weatherEntity.weatherDetails);

        emit(getWeatherState);
      }
    });
  }
}
