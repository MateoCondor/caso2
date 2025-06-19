import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/search_bar_widget.dart';
import 'weather_detail_view.dart';

/// Vista principal que muestra la lista de climas y permite búsquedas
/// Incluye barra de búsqueda, filtros y navegación a detalles
class WeatherListView extends StatefulWidget {
  const WeatherListView({super.key});

  @override
  State<WeatherListView> createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {
  final TextEditingController _filterController = TextEditingController();
  String _filterQuery = '';

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Mundial'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Botón para limpiar todos los datos
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              if (weatherProvider.hasData) {
                return IconButton(
                  onPressed: () => _showClearDialog(context, weatherProvider),
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Limpiar todo',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              return SearchBarWidget(
                onSearch: (cityName) => weatherProvider.searchWeather(cityName),
                isLoading: weatherProvider.isSearching,
                hintText: 'Buscar ciudad (ej: Madrid, Tokyo)',
              );
            },
          ),
          
          // Barra de filtro (solo si hay datos)
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              if (weatherProvider.hasData) {
                return _buildFilterBar();
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Lista de climas o estados vacíos
          Expanded(
            child: Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                return _buildBody(weatherProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la barra de filtro
  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _filterController,
        decoration: InputDecoration(
          hintText: 'Filtrar ciudades...',
          prefixIcon: const Icon(Icons.filter_list),
          suffixIcon: _filterQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _filterController.clear();
                    setState(() {
                      _filterQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onChanged: (value) {
          setState(() {
            _filterQuery = value;
          });
        },
      ),
    );
  }

  /// Construye el cuerpo principal basado en el estado
  Widget _buildBody(WeatherProvider weatherProvider) {
    // Estado de error
    if (weatherProvider.state == WeatherState.error) {
      return _buildErrorState(weatherProvider);
    }
    
    // Estado inicial sin datos
    if (weatherProvider.state == WeatherState.initial) {
      return _buildEmptyState();
    }
    
    // Lista con datos
    if (weatherProvider.hasData) {
      return _buildWeatherList(weatherProvider);
    }
    
    // Estado de carga inicial
    return _buildLoadingState();
  }

  /// Construye el estado vacío inicial
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_queue,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '¡Bienvenido!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Busca una ciudad para ver su clima',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: null, // Solo para mostrar el ejemplo
            icon: const Icon(Icons.search),
            label: const Text('Ejemplo: "Madrid"'),
          ),
        ],
      ),
    );
  }

  /// Construye el estado de carga
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Buscando clima...'),
        ],
      ),
    );
  }

  /// Construye el estado de error
  Widget _buildErrorState(WeatherProvider weatherProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              weatherProvider.errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Limpiar el error para permitir nueva búsqueda
              // El provider se resetea automáticamente en la próxima búsqueda
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Intentar de nuevo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de climas
  Widget _buildWeatherList(WeatherProvider weatherProvider) {
    final filteredWeather = weatherProvider.filterWeather(_filterQuery);
    
    if (filteredWeather.isEmpty && _filterQuery.isNotEmpty) {
      return _buildNoResultsState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: filteredWeather.length,
      itemBuilder: (context, index) {
        final weather = filteredWeather[index];
        return WeatherCard(
          weather: weather,
          onTap: () => _navigateToDetail(weather),
          onDelete: () => _showDeleteDialog(
            context,
            weatherProvider,
            weatherProvider.weatherList.indexOf(weather),
            weather.cityName,
          ),
        );
      },
    );
  }

  /// Construye el estado sin resultados de filtro
  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Sin resultados',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No se encontraron ciudades con "$_filterQuery"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Navega a la vista de detalles
  void _navigateToDetail(weather) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherDetailView(weather: weather),
      ),
    );
  }

  /// Muestra el diálogo de confirmación para eliminar
  void _showDeleteDialog(
    BuildContext context,
    WeatherProvider provider,
    int index,
    String cityName,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar ciudad'),
          content: Text('¿Estás seguro de que quieres eliminar $cityName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                provider.removeWeather(index);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$cityName eliminada')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  /// Muestra el diálogo de confirmación para limpiar todo
  void _showClearDialog(BuildContext context, WeatherProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar todo'),
          content: const Text('¿Estás seguro de que quieres eliminar todas las ciudades?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                provider.clearData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todas las ciudades eliminadas')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Limpiar'),
            ),
          ],
        );
      },
    );
  }
}