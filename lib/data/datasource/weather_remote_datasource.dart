import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// Data source remoto para consultar la API de OpenWeatherMap
class WeatherRemoteDataSource {
  final http.Client _client;
  
  static const String _apiKey = 'ee14acdba16ea4479272a798437d0722';
  // Cambiar HTTP por HTTPS
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherRemoteDataSource(this._client);

  /// Obtiene los datos del clima para una ciudad específica
  Future<WeatherModel> getWeatherByCity(String cityName) async {
    final url = Uri.parse('$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric');
    
    try {
      final response = await _client.get(url);
      
      print('URL solicitada: $url');
      print('Código de respuesta: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Respuesta exitosa: ${response.body}');
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Clave API inválida o expirada. Verifica tu API key en OpenWeatherMap.');
      } else if (response.statusCode == 404) {
        throw Exception('Ciudad no encontrada: $cityName');
      } else if (response.statusCode == 429) {
        throw Exception('Límite de peticiones excedido. Intenta más tarde.');
      } else {
        print('Error HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Error al consultar el clima: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la petición: $e');
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Error de conexión: Verifica tu conexión a Internet');
      }
    }
  }
}