import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_keys.dart'; // API anahtarlarını içe aktarın

class SearchScreen extends StatefulWidget {
  final String apiKey;

  const SearchScreen({super.key, required this.apiKey});
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  String cityName = '';
  String weatherInfo = '';
  String weatherIcon = '';
  bool isLoading = false;

  Future<void> fetchWeatherByCity(String city) async {
    setState(() {
      isLoading = true;
      weatherInfo = '';
    });

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=${ApiKeys.openWeatherMapApiKey}&lang=tr');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        weatherInfo =
            'Sıcaklık: ${data['main']['temp']}°C\nAçıklama: ${data['weather'][0]['description']}\nNem: ${data['main']['humidity']}%\nHissedilen: ${data['main']['feels_like']}°C';
        weatherIcon = data['weather'][0]['icon'];
        isLoading = false;
      });
    } else {
      setState(() {
        weatherInfo = 'Hava durumu bilgisi alınamadı.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum Arama'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.lightBlue[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Şehir veya Ülke Adı',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  cityName = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (cityName.trim().isNotEmpty) {
                  fetchWeatherByCity(cityName.trim());
                }
              },
              icon: const Icon(Icons.cloud),
              label: const Text('Hava Durumunu Getir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : weatherInfo.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (weatherIcon.isNotEmpty)
                              Image.network(
                                'https://openweathermap.org/img/wn/$weatherIcon@4x.png',
                              ),
                            const SizedBox(height: 10),
                            Text(
                              weatherInfo,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}