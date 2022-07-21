import 'package:catchfish/features/gameBoard/data/datasources/weather/weather_remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/weather/weather_model.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/weather/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  @override
  Future<WeatherModel> getWeatherDetails(
      double latitude, double longitude) async {
    WeatherRemoteDatasource weatherRemoteDatasource = WeatherRemoteDatasource();
    WeatherModel weatherModel =
        await weatherRemoteDatasource.getWeatherDetails(latitude, longitude);

    return weatherModel;
  }
}
