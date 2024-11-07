import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'search_screen.dart';
import 'api_keys.dart'; // API anahtarlarını içe aktarın

Future<void> main() async {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = ApiKeys.openWeatherMapApiKey; // API anahtarını kullanın
  String weatherInfo = 'Yükleniyor...';
  String weatherIcon = '';
  bool isLoading = true;

  // Yeni eklenen değişkenler
  String cityName = '';
  double temp = 0.0;
  double feelsLike = 0.0;
  int humidity = 0;
  String description = '';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servislerinin etkin olup olmadığını kontrol edin
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lat = position.latitude;
    final lon = position.longitude;
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey&lang=tr');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // API'den gelen ek verileri alın
      setState(() {
        cityName = data['name'];
        temp = data['main']['temp'];
        feelsLike = data['main']['feels_like'];
        humidity = data['main']['humidity'];
        description = data['weather'][0]['description'];
        weatherIcon = data['weather'][0]['icon'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Hava Durumu'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.blueAccent, // Arka plan rengi
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (weatherIcon.isNotEmpty)
                      Image.network(
                        'https://openweathermap.org/img/wn/$weatherIcon@2x.png',
                        width: 100,
                        height: 100,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      '$cityName',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sıcaklık: ${temp.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Hissedilen: ${feelsLike.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Nem: $humidity%',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$description',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sol boşluk
            const SizedBox(width: 30),
            // Sol alt köşedeki buton
            FloatingActionButton(
              heroTag: 'searchButton', // Benzersiz heroTag ekleyin
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(apiKey: apiKey),
                  ),
                );
              },
              child: const Icon(Icons.search),
              backgroundColor: Colors.blue,
            ),
            // Ortadaki boşluk
            const Spacer(),
            // Sağ alt köşedeki buton
            FloatingActionButton(
              heroTag: 'refreshButton', // Benzersiz heroTag ekleyin
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                fetchWeather();
              },
              child: const Icon(Icons.refresh),
              backgroundColor: Colors.blue,
            ),
            // Sağ boşluk
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}