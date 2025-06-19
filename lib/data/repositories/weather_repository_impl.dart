import '../../domain/entities/weather_entity.dart';
import '../datasource/weather_remote_datasource.dart';

/// Implementación del repositorio de clima
/// Actúa como intermediario entre los casos de uso y el data source
class WeatherRepositoryImpl {
  final WeatherRemoteDataSource _remoteDataSource;

  WeatherRepositoryImpl(this._remoteDataSource);

  /// Obtiene los datos del clima para una ciudad
  /// [cityName] - Nombre de la ciudad a consultar
  /// Retorna una WeatherEntity con los datos del clima
  Future<WeatherEntity> getWeatherByCity(String cityName) async {
    try {
      // Delegar la consulta al data source remoto
      final weatherModel = await _remoteDataSource.getWeatherByCity(cityName);
      
      // Retornar la entidad (el modelo extiende de la entidad)
      return weatherModel;
    } catch (e) {
      // Re-lanzar la excepción para que sea manejada por la capa de presentación
      rethrow;
    }
  }
}