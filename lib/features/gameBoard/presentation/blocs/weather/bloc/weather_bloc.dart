import 'package:bloc/bloc.dart';
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
        WeatherFactory wf = WeatherFactory("f5032883316e150d0391daf1cb11d680");
        Weather w =
            await wf.currentWeatherByLocation(event.latitude, event.longitude);
        String str = "";
        String cloudiness = w.cloudiness.toString();
        String weatherDescription = w.weatherDescription.toString();
        if (weatherDescription.isNotEmpty) {
          str = str + "weather:".tr() + weatherDescription + "\n";
        }
        String temperature = w.temperature.toString();
        if (temperature.isNotEmpty) {
          str = str + "temp:".tr() + temperature + "\n";
        }
        String tempFeelsLike = w.tempFeelsLike.toString();
        if (tempFeelsLike.isNotEmpty) {
          str = str + "feels_like:".tr() + tempFeelsLike + "\n";
        }
        String tempMax = w.tempMax.toString();
        if (tempMax.isNotEmpty) {
          str = str + "max_temp:".tr() + tempMax + "\n";
        }
        String tempMin = w.tempMin.toString();
        if (tempMin.isNotEmpty) {
          str = str + "min_temp:".tr() + tempMin + "\n";
        }
        String humidity = w.humidity.toString();
        if (humidity.isNotEmpty) {
          str = str + "humidity:".tr() + humidity + "\n";
        }
        if (cloudiness.isNotEmpty) {
          str = str + "cloudiness:".tr() + cloudiness + "\n";
        }

        String windDegree = w.windDegree.toString();
        if (windDegree.isNotEmpty) {
          str = str + "Wind Degree: ".tr() + windDegree + "\n";
        }
        String windGust = w.windGust.toString();
        if (windGust.isNotEmpty) {
          str = str + "wind_gust:".tr() + windGust + "\n";
        }
        String windSpeed = w.windSpeed.toString();
        if (windSpeed.isNotEmpty) {
          str = str + "wind_speed:".tr() + windSpeed + "\n";
        }

        String pressure = w.pressure.toString();
        if (pressure.isNotEmpty) {
          str = str + "pressure:".tr() + pressure + "\n";
        }
        String sunrise = w.sunrise.toString();
        if (sunrise.isNotEmpty) {
          str = str +
              "sunrise:".tr() +
              sunrise.substring(sunrise.indexOf(" ") + 1) +
              "\n";
        }
        String sunset = w.sunset.toString();
        if (sunset.isNotEmpty) {
          str = str +
              "sunset:".tr() +
              sunset.substring(sunset.indexOf(" ") + 1) +
              "\n";
        }

        GetWeatherState getWeatherState = GetWeatherState(weatherDetails: str);

        emit(getWeatherState);
      }
    });
  }
}
