import 'package:apiandroid/models/weathermodel.dart';
import 'package:apiandroid/services/weatherservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherService = Weatherservice();

  Weather? _weather;
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeatherData(cityName);
      print(weather.toString());
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) "assets/json/sunny.json";

    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return "assets/json/cloudy.json";

      case 'drizzle':
        return "assets/json/sunny_rainy.json";
      case 'rain':
      case 'shower rain':
        return "assets/json/rain.json";
      case 'thunderstorm':
        return "assets/json/thunder.json";
      case 'clear':
        return "assets/json/sunny.json";
      default:
        return "assets/json/sunny.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(height * 0.022),
          child: Container(
            height: height * 0.20,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height * 0.20,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 40),
                        child: Text(
                          _weather?.cityName ?? "Loading city...",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        ),
                             Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "${_weather?.temperature}°C",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          DateFormat.yMMMEd().format(DateTime.now()),
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 89, 87, 87)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: "Dismiss", onPressed: () {}),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
