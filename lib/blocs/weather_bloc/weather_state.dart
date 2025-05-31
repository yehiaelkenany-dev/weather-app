part of 'weather_bloc.dart';


@immutable
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final String location;
  final String weatherIcon;
  final int temperature;
  final int windSpeed;
  final int humidity;
  final int cloud;
  final String currentDate;
  final List hourlyWeatherForecast;
  final List dailyWeatherForecast;
  final String currentWeatherStatus;

  const WeatherLoaded({
    required this.location,
    required this.weatherIcon,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.cloud,
    required this.currentDate,
    required this.hourlyWeatherForecast,
    required this.dailyWeatherForecast,
    required this.currentWeatherStatus,
  });

  @override
  List<Object> get props => [
    location,
    weatherIcon,
    temperature,
    windSpeed,
    humidity,
    cloud,
    currentDate,
    hourlyWeatherForecast,
    dailyWeatherForecast,
    currentWeatherStatus,
  ];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}