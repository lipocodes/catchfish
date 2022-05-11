import 'package:catchfish/features/gameBoard/data/models/weather/weather_model.dart';
import 'package:catchfish/features/gameBoard/data/repositories/weather_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/weather/weather_entity.dart';

class WeatherUsecase {
  Future<WeatherEntity> getWeatherDetails(
      double latitude, double longitude) async {
    WeatherRepositoryImpl weatherRepositoryImpl = WeatherRepositoryImpl();
    WeatherModel weatherModel =
        await weatherRepositoryImpl.getWeatherDetails(latitude, longitude);

    WeatherEntity weatherEntity =
        WeatherEntity(weatherDetails: weatherModel.weatherDetails);
    return weatherEntity;
  }
}
