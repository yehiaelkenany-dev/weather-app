import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../api/api.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final Api _api;

  WeatherBloc(this._api) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  static String _getShortLocationName(String s) {
    List<String> wordList = s.split(" ");
    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  Future<void> _onFetchWeather(
      FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      var searchResult = await _api.searchLocation(event.cityName);
      if (searchResult != null && searchResult.isNotEmpty) {
        final Map<String, dynamic> firstLocationData = searchResult[0];

        String location = _getShortLocationName(firstLocationData['name']);

        var forecastData =
        await _api.fetchForecast(firstLocationData['name'], 7);
        if (forecastData != null) {
          var current = forecastData['current'];
          var forecastDay = forecastData['forecast']['forecastday'];
          if (current != null && forecastDay != null) {
            int temperature = (current['temp_c'] as double).toInt();
            int windSpeed = (current['wind_kph'] as double).toInt();
            int humidity = current['humidity'] as int;
            int cloud = current['cloud'] as int;
            String currentWeatherStatus = current['condition']['text'];

            String dateString = forecastDay[0]['date'];
            DateTime dateTime = DateTime.parse(dateString);
            String currentDate = DateFormat('EEEE, d MMMM').format(dateTime);

            List hourlyWeatherForecast = forecastDay[0]['hour'];
            List dailyWeatherForecast = forecastDay;
            String weatherIcon =
                "${currentWeatherStatus.replaceAll(' ', '').toLowerCase()}.png";

            emit(WeatherLoaded(
              location: location,
              weatherIcon: weatherIcon,
              temperature: temperature,
              windSpeed: windSpeed,
              humidity: humidity,
              cloud: cloud,
              currentDate: currentDate,
              hourlyWeatherForecast: hourlyWeatherForecast,
              dailyWeatherForecast: dailyWeatherForecast,
              currentWeatherStatus: currentWeatherStatus,
            ));
          } else {
            emit(const WeatherError("Invalid forecast data received."));
          }
        } else {
          emit(const WeatherError("Failed to load forecast data."));
        }
      } else {
        emit(const WeatherError("No data returned for the city."));
      }
    } catch (e) {
      emit(WeatherError("Error fetching weather data: ${e.toString()}"));
    }
  }
}