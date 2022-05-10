import 'package:bloc/bloc.dart';
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
        WeatherFactory wf = WeatherFactory("f5032883316e150d0391daf1cb11d680");
        Weather w =
            await wf.currentWeatherByLocation(event.latitude, event.longitude);
        GetWeatherState getWeatherState =
            GetWeatherState(weatherDetails: w.toString());

        emit(getWeatherState);
      }
    });
  }
}
