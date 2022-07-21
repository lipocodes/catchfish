import 'package:catchfish/features/gameBoard/data/models/weather/weather_model.dart';

abstract class WeatherRepository {
  Future<WeatherModel> getWeatherDetails(double latitude, double longitude);
}
