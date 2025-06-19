import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/weather_entity.dart';

/// Widget que muestra la información del clima en formato de tarjeta
/// Incluye ícono del clima, temperatura, nombre de ciudad y humedad
class WeatherCard extends StatelessWidget {
  final WeatherEntity weather;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const WeatherCard({
    super.key,
    required this.weather,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getGradientColor(weather.weatherMain)[0],
            _getGradientColor(weather.weatherMain)[1],
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _getGradientColor(weather.weatherMain)[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Ícono del clima con contenedor circular
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: weather.iconUrl,
                    width: 60,
                    height: 60,
                    placeholder: (context, url) => const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.cloud,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Información de la ciudad y clima
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre de la ciudad
                      Text(
                        weather.cityName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Estado del clima
                      Text(
                        weather.weatherMain,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Humedad con ícono
                      Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Humedad: ${weather.formattedHumidity}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Temperatura y botón de eliminar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Temperatura destacada
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        weather.formattedTemperature,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Botón de eliminar mejorado
                    if (onDelete != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.white,
                          iconSize: 20,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Obtiene los colores del gradiente según el clima
  List<Color> _getGradientColor(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return [const Color(0xFFFFB74D), const Color(0xFFFF9800)]; // Naranja soleado
      case 'clouds':
        return [const Color(0xFF90A4AE), const Color(0xFF607D8B)]; // Gris nublado
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF64B5F6), const Color(0xFF1976D2)]; // Azul lluvia
      case 'snow':
        return [const Color(0xFFE1F5FE), const Color(0xFF81D4FA)]; // Azul claro nieve
      case 'thunderstorm':
        return [const Color(0xFF455A64), const Color(0xFF263238)]; // Gris oscuro tormenta
      case 'mist':
      case 'fog':
        return [const Color(0xFFCFD8DC), const Color(0xFF90A4AE)]; // Gris claro niebla
      default:
        return [const Color(0xFF42A5F5), const Color(0xFF1E88E5)]; // Azul por defecto
    }
  }
}