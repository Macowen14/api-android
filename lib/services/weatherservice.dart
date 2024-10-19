import 'dart:convert';

import 'package:apiandroid/models/weathermodel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Weatherservice {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  static const API_KEY = 'f1fd87d085c9d19992fb6e5f415dedf0';

  Future<Weather> getWeatherData(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      Weather weather = Weather.fromJson(jsonResponse);
      return weather;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placeMarks[0].locality;
    return city ?? 'Empty';
  }
}
