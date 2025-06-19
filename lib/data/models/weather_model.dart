import '../../domain/entities/weather_entity.dart';

/// Modelo de datos que representa la respuesta de la API
/// Se encarga de la serialización/deserialización de JSON
class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.cityName,
    required super.weatherMain,
    required super.weatherIcon,
    required super.temperature,
    required super.humidity,
  });

  /// Factory constructor para crear una instancia desde JSON
  /// [json] - Mapa con los datos de la API de OpenWeatherMap
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String,
      weatherMain: json['weather'][0]['main'] as String,
      weatherIcon: json['weather'][0]['icon'] as String,
      // Convertir temperatura de Kelvin a Celsius
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      humidity: json['main']['humidity'] as int,
    );
  }

  /// Convierte la instancia a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'weather': [
        {
          'main': weatherMain,
          'icon': weatherIcon,
        }
      ],
      'main': {
        'temp': temperature + 273.15, // Convertir de vuelta a Kelvin
        'humidity': humidity,
      },
    };
  }
}