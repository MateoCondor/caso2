import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/weather_entity.dart';

/// Vista que muestra los detalles completos del clima de una ciudad
/// Incluye información ampliada y un diseño más detallado
class WeatherDetailView extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherDetailView({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.cityName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tarjeta principal con el ícono y temperatura
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Ícono del clima grande
                    CachedNetworkImage(
                      imageUrl: weather.iconUrl,
                      width: 120,
                      height: 120,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.cloud,
                        size: 120,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Temperatura grande
                    Text(
                      weather.formattedTemperature,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Estado del clima
                    Text(
                      weather.weatherMain,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Información detallada
            _buildDetailCard(context),
            const SizedBox(height: 24),
            
            // Información adicional
            _buildAdditionalInfo(context),
          ],
        ),
      ),
    );
  }

  /// Construye la tarjeta con detalles del clima
  Widget _buildDetailCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Clima',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Fila con íconos y datos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Humedad
                _buildDetailItem(
                  context,
                  Icons.water_drop,
                  'Humedad',
                  weather.formattedHumidity,
                  Colors.blue,
                ),
                
                // Temperatura
                _buildDetailItem(
                  context,
                  Icons.thermostat,
                  'Temperatura',
                  weather.formattedTemperature,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un item de detalle con ícono y texto
  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Construye la sección de información adicional
  Widget _buildAdditionalInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información de la Ciudad',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text('Ciudad'),
              subtitle: Text(weather.cityName),
            ),
            
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Condición'),
              subtitle: Text(weather.weatherMain),
            ),
            
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Código de Ícono'),
              subtitle: Text(weather.weatherIcon),
            ),
          ],
        ),
      ),
    );
  }
}