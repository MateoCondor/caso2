import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// Importaciones de la arquitectura
import 'data/datasource/weather_remote_datasource.dart';
import 'data/repositories/weather_repository_impl.dart';
import 'application/usecases/get_weather_usecase.dart';
import 'presentation/providers/weather_provider.dart';
import 'presentation/views/weather_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Configuración de dependencias usando Provider
        // Creamos el provider con todas las dependencias inyectadas
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) {
            // Inyección de dependencias manual (Dependency Injection)
            final httpClient = http.Client();
            final remoteDataSource = WeatherRemoteDataSource(httpClient);
            final repository = WeatherRepositoryImpl(remoteDataSource);
            final useCase = GetWeatherUseCase(repository);

            return WeatherProvider(useCase);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Esquema de colores más moderno
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3), // Azul más vibrante
            brightness: Brightness.light,
          ),
          useMaterial3: true,

          // Configuración de fuentes
          fontFamily: 'Roboto',

          // Personalización de componentes
          cardTheme: CardTheme(
            elevation: 6,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),

          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            titleTextStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // Personalización de botones
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Personalización de inputs
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
            ),
          ),
        ),

        // Vista principal de la aplicación
        home: const WeatherListView(),
      ),
    );
  }
}
