import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/components/weather_item.dart';
import 'package:weather_app/constants.dart';

class DetailsScreen extends StatefulWidget {
  final dynamic dailyWeatherForecast;

  const DetailsScreen({super.key, this.dailyWeatherForecast});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final AppColors _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.sizeOf(context).height;
    final deviceWidth = MediaQuery.sizeOf(context).width;

    Map<String, dynamic> getWeatherForecast(int index) {
      if (widget.dailyWeatherForecast == null || index < 0 || index >= widget.dailyWeatherForecast.length) {
        return {
          'maxWindSpeed': 0,
          'avgHumidity': 0,
          'chanceOfRain': 0,
          'forecastDate': 'N/A',
          'weatherName': 'N/A',
          'weatherIcon': 'unknown.png',
          'minTemperature': 0,
          'maxTemperature': 0,
        };
      }

      final dayData = widget.dailyWeatherForecast[index]['day'];
      final conditionData = dayData['condition'];
      int maxWindSpeed = (dayData['maxwind_kph'] as double).toInt();
      int avgHumidity = (dayData['avghumidity'] as num).toInt();
      int chanceOfRain = (dayData['daily_chance_of_rain'] as num).toInt();

      var parsedDate = DateTime.parse(
        widget.dailyWeatherForecast[index]['date'],
      );
      var forecastDate = DateFormat('EEEE, d MMMM').format(parsedDate);

      String weatherName = conditionData['text'];
      String weatherIcon =
          '${weatherName.replaceAll(' ', '').toLowerCase()}.png';

      final List<String> availableIcons = [
        'clear.png',
        'cloud.png',
        'cloudy.png',
        'fog.png',
        'heavycloud.png',
        'heavyrain.png',
        'humidity.png',
        'lightdrizzle.png',
        'lightrain.png',
        'lightrainshower.png',
        // 'menu.png' - not a weather icon
        'mist.png',
        'moderateorheavyrainshower.png',
        'moderateorheavyrainwiththunder.png',
        'moderaterain.png',
        'moderaterainattimes.png',
        'overcast.png',
        'partlycloudy.png',
        'patchylightdrizzle.png',
        'patchylightrain.png',
        'patchylightrainwiththunder.png',
        'patchyrainnearby.png',
        'patchyrainpossible.png',
        // 'pin.png' - not a weather icon
        // 'profile.png' - not a weather icon
        'sunny.png',
        'thunderyoutbreakspossible.png',
        'unknown.png',
        // 'windspeed.png' - not a weather icon
      ];
      if (!availableIcons.contains(weatherIcon)) {
        weatherIcon = 'unknown.png';
      }

      int minTemperature = (dayData['mintemp_c'] as double).toInt();
      int maxTemperature = (dayData['maxtemp_c'] as double).toInt();

      return {
        'maxWindSpeed': maxWindSpeed,
        'avgHumidity': avgHumidity,
        'chanceOfRain': chanceOfRain,
        'forecastDate': forecastDate,
        'weatherName': weatherName,
        'weatherIcon': weatherIcon,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature,
      };
    }
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: const Text('Forecasts', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: deviceHeight * .75,
              width: deviceWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -100,
                    right: 20,
                    left: 20,
                    child: Container(
                      height: 300,
                      width: deviceWidth * .7,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [Color(0xFFA9C1F5), Color(0XFF6696F5)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: .1),
                            offset: const Offset(0, 25),
                            blurRadius: 3,
                            spreadRadius: -10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Image.asset(
                              'assets/images/${getWeatherForecast(0)['weatherIcon']}',
                              width: 150,
                            ),
                          ),
                          Positioned(
                            top: 165,
                            left: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                getWeatherForecast(0)['weatherName'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 20,
                            child: Container(
                              width: deviceWidth * .8,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem(
                                    unit: " km/h",
                                    imageURL: 'assets/images/windspeed.png',
                                    value: getWeatherForecast(
                                      0,
                                    )['maxWindSpeed'],
                                  ),
                                  WeatherItem(
                                    unit: " %",
                                    imageURL: 'assets/images/humidity.png',
                                    value: getWeatherForecast(
                                      0,
                                    )['avgHumidity'],
                                  ),
                                  WeatherItem(
                                    unit: " km/h",
                                    imageURL: 'assets/images/lightrain.png',
                                    value: getWeatherForecast(
                                      0,
                                    )['chanceOfRain'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getWeatherForecast(
                                    0,
                                  )['maxTemperature'].toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = _appColors.shader,
                                  ),
                                ),
                                Text(
                                  "°C",
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = _appColors.shader,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 320,
                            left: 0,
                            child: SizedBox(
                              height: 400,
                              width: deviceWidth * .9,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: widget.dailyWeatherForecast?.length ?? 0, // Ensure null-safety
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return const SizedBox.shrink();
                                    }

                                    final forecast = getWeatherForecast(index);
                                    return Card(
                                      elevation: 3.0,
                                      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  forecast['forecastDate'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF6696F5),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${forecast['minTemperature']}°C",
                                                      style: TextStyle(
                                                        color: AppColors.greyColor,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Text(" / ", style: TextStyle(color: Colors.grey, fontSize: 20)),
                                                    Text(
                                                      "${forecast['maxTemperature']}°C",
                                                      style: TextStyle(
                                                        color: AppColors.blackColor,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/${forecast['weatherIcon']}',
                                                      width: 30,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      forecast['weatherName'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${forecast['chanceOfRain']} %',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Image.asset(
                                                      'assets/images/lightrain.png',
                                                      width: 30,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
