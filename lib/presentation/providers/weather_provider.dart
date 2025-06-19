import 'package:flutter/foundation.dart';
import '../../application/usecases/get_weather_usecase.dart';
import '../../domain/entities/weather_entity.dart';

/// Estados posibles de la consulta del clima
enum WeatherState {
  initial,    // Estado inicial
  loading,    // Cargando datos
  loaded,     // Datos cargados exitosamente
  error,      // Error al cargar datos
}

/// Provider que maneja el estado de la aplicación relacionado con el clima
/// Utiliza ChangeNotifier para notificar cambios a los widgets
class WeatherProvider extends ChangeNotifier {
  final GetWeatherUseCase _getWeatherUseCase;

  WeatherProvider(this._getWeatherUseCase);

  // Estado privado
  WeatherState _state = WeatherState.initial;
  List<WeatherEntity> _weatherList = [];
  String _errorMessage = '';
  bool _isSearching = false;

  // Getters públicos para acceder al estado
  WeatherState get state => _state;
  List<WeatherEntity> get weatherList => _weatherList;
  String get errorMessage => _errorMessage;
  bool get isSearching => _isSearching;
  bool get hasData => _weatherList.isNotEmpty;

  /// Busca el clima de una ciudad y lo agrega a la lista
  /// [cityName] - Nombre de la ciudad a buscar
  Future<void> searchWeather(String cityName) async {
    // Validar entrada
    if (cityName.trim().isEmpty) return;

    // Verificar si la ciudad ya está en la lista
    final cityExists = _weatherList.any(
      (weather) => weather.cityName.toLowerCase() == cityName.toLowerCase(),
    );
    
    if (cityExists) {
      _errorMessage = 'La ciudad $cityName ya está en la lista';
      _state = WeatherState.error;
      notifyListeners();
      return;
    }

    // Cambiar estado a cargando
    _state = WeatherState.loading;
    _isSearching = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Ejecutar caso de uso
      final weather = await _getWeatherUseCase.execute(cityName);
      
      // Agregar a la lista
      _weatherList.add(weather);
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      // Manejar error
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Filtra la lista de climas según el texto de búsqueda
  /// [query] - Texto a buscar en los nombres de las ciudades
  List<WeatherEntity> filterWeather(String query) {
    if (query.isEmpty) return _weatherList;
    
    return _weatherList.where((weather) =>
      weather.cityName.toLowerCase().contains(query.toLowerCase()) ||
      weather.weatherMain.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// Elimina una ciudad de la lista
  /// [index] - Índice de la ciudad a eliminar
  void removeWeather(int index) {
    if (index >= 0 && index < _weatherList.length) {
      _weatherList.removeAt(index);
      
      // Si la lista queda vacía, volver al estado inicial
      if (_weatherList.isEmpty) {
        _state = WeatherState.initial;
      }
      
      notifyListeners();
    }
  }

  /// Limpia todos los datos
  void clearData() {
    _weatherList.clear();
    _state = WeatherState.initial;
    _errorMessage = '';
    _isSearching = false;
    notifyListeners();
  }
}