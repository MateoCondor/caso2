import '../../../domain/entities/weather_entity.dart';
import '../../data/repositories/weather_repository_impl.dart';

/// Caso de uso para obtener información del clima
/// Contiene la lógica de negocio para consultar el clima de una ciudad
class GetWeatherUseCase {
  final WeatherRepositoryImpl _repository;

  GetWeatherUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener el clima de una ciudad
  /// [cityName] - Nombre de la ciudad a consultar
  /// Retorna un Future con la entidad WeatherEntity
  /// Puede lanzar excepciones si la ciudad no existe o hay problemas de red
  Future<WeatherEntity> execute(String cityName) async {
    // Validar que el nombre de la ciudad no esté vacío
    if (cityName.trim().isEmpty) {
      throw ArgumentError('El nombre de la ciudad no puede estar vacío');
    }

    // Delegar la consulta al repositorio
    return await _repository.getWeatherByCity(cityName.trim());
  }
}