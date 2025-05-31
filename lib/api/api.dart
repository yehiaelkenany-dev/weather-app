import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants.dart';

  class Api {
  // Get forecast data
  Future<Map<String, dynamic>?> fetchForecast(String location, int days) async {
  final url = Uri.parse(
  '${AppConstants.baseUrl}/forecast.json?key=${AppConstants.apiKey}&q=$location&days=$days&aqi=no&alerts=no',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
  return json.decode(response.body);
  } else {
  print('Failed to load forecast: ${response.statusCode}');
  return null;
  }
  }

  // Search for a location
  Future<List<dynamic>?> searchLocation(String query) async {
  final url = Uri.parse(
  '${AppConstants.baseUrl}/search.json?key=${AppConstants.apiKey}&q=$query',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
  return json.decode(response.body);
  } else {
  print('Failed to search location: ${response.statusCode}');
  return null;
  }
  }

}