import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'models.dart';
import 'models/time_series.dart';

abstract class DataSource {
  Future<WeeklyForecastDto> getWeeklyForecast();

  Future<WeatherChartData> getChartData();
}

class FakeDataSource implements DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/weekly_forecast.json");
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }

  @override
  Future<WeatherChartData> getChartData() async {
    final json = await rootBundle.loadString("assets/chart_data.json");
    return WeatherChartData.fromJson(jsonDecode(json));
  }
}

class RealDataSource implements DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final location = await Location.instance.getLocation();
    final url = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${location.latitude}',
      'longitude': '${location.longitude}',
      'daily': [
        'weather_code',
        'temperature_2m_max',
        'temperature_2m_min',
        'sunrise',
        'sunset'
      ],
      'timezone': 'Europe/Berlin',
    });

    final response = await http.get(url);
    final json = response.body;
    return WeeklyForecastDto.fromJson(jsonDecode
      (
        json
    )
    );
  }

  @override
  Future<WeatherChartData> getChartData() async {
    final location = await Location.instance.getLocation();
    final url = Uri.https("api.open-meteo.com", '/v1/forecast', {
    'latitude': '${location.latitude}',
    'longitude': '${location.longitude}',
    'daily': [
      'temperature_2m_max',
      'temperature_2m_min',
    ],
    'timezone': 'Europe/Berlin',
  });

  final response = await http.get(url);
    return WeatherChartData.fromJson(jsonDecode(response.body));
  }
}
