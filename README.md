# Hava Durumu Uygulaması / Weather App

## Türkçe

### Açıklama
Bu uygulama, kullanıcının bulunduğu konuma göre hava durumu bilgilerini gösterir ve ayrıca kullanıcıların belirli bir konumu arayarak o konumun hava durumu bilgilerini öğrenmelerini sağlar.

### Kullanılan Teknolojiler
- Flutter
- Dart
- HTTP
- Geolocator
- OpenWeatherMap API

### Kurulum ve Kullanım
1. Bu projeyi bilgisayarınıza klonlayın:
   ```sh
   git clone https://github.com/hamer1818/flutter_wheater_app.git
   cd flutter_wheater_app
    ```
2. Gerekli paketleri yükleyin:
   ```sh
   flutter pub get
    ```
3. lib/api_keys.dart dosyasını oluşturun ve API anahtarınızı ekleyin:
    ```dart
    const String apiKey = 'API_ANAHTARINIZ';
    ```
4. Uygulamayı çalıştırın:
    ```sh
    flutter run
    ```

## English

### Description

This application shows the weather information according to the user's location and also allows users to search for the weather information of a specific location.

### Technologies Used
- Flutter
- Dart
- HTTP
- Geolocator
- OpenWeatherMap API

### Installation and Usage
1. Clone this project to your computer:
   ```sh
    git clone https://github.com/hamer1818/flutter_wheater_app.git
    cd flutter_wheater_app
     ```
2. Install the required packages:
    ```sh
    flutter pub get
      ```
3. Create lib/api_keys.dart file and add your API key:
    ```dart
    const String apiKey = 'YOUR_API_KEY';
    ```
4. Run the application:
    ```sh
    flutter run
    ```
