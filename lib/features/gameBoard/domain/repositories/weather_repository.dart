import 'package:catchfish/features/gameBoard/data/models/weather_model.dart';

abstract class WeatherRepository {
  Future<WeatherModel> getWeatherDetails(double latitude, double longitude);
}
