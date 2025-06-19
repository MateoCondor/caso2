/// Entidad que representa los datos del clima de una ciudad
/// Esta es la representación más pura de los datos en el dominio
class WeatherEntity {
  final String cityName;        // Nombre de la ciudad
  final String weatherMain;     // Estado general del clima (Clear, Rain, etc.)
  final String weatherIcon;     // Código del ícono del clima
  final double temperature;     // Temperatura actual en Celsius
  final int humidity;          // Humedad en porcentaje

  const WeatherEntity({
    required this.cityName,
    required this.weatherMain,
    required this.weatherIcon,
    required this.temperature,
    required this.humidity,
  });

  /// Método de conveniencia para obtener la URL completa del ícono
  String get iconUrl => 'https://openweathermap.org/img/wn/$weatherIcon@2x.png';

  /// Método para obtener la temperatura formateada
  String get formattedTemperature => '${temperature.round()}°C';

  /// Método para obtener la humedad formateada
  String get formattedHumidity => '$humidity%';
}