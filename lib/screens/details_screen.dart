import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/components/weather_item.dart';
import 'package:weather_app/constants.dart';

class DetailsScreen extends StatefulWidget {
  final dailyWeatherForecast;

  const DetailsScreen({super.key, this.dailyWeatherForecast});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final AppColors _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.sizeOf(context).height;
    final _deviceWidth = MediaQuery.sizeOf(context).width;

    Map<String, dynamic> _getWeatherForecast(int index) {
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

      int minTemperature = (dayData['mintemp_c'] as double).toInt();
      int maxTemperature = (dayData['maxtemp_c'] as double).toInt();

      Map<String, dynamic> forecastData = {
        'maxWindSpeed': maxWindSpeed,
        'avgHumidity': avgHumidity,
        'chanceOfRain': chanceOfRain,
        'forecastDate': forecastDate,
        'weatherName': weatherName,
        'weatherIcon': weatherIcon,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature,
      };

      return forecastData;
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
                print("Settings Tapped");
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
              height: _deviceHeight * .75,
              width: _deviceWidth,
              decoration: BoxDecoration(
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
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      height: 300,
                      width: _deviceWidth * .7,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [Color(0xFFA9C1F5), Color(0XFF6696F5)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: .1),
                            offset: Offset(0, 25),
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
                              'assets/images/${_getWeatherForecast(0)['weatherIcon']}',
                              width: 150,
                            ),
                          ),
                          Positioned(
                            top: 165,
                            left: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                _getWeatherForecast(0)['weatherName'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 20, // momken 40
                            child: Container(
                              width: _deviceWidth * .8,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem(
                                    unit: "km/h",
                                    imageURL: 'assets/images/windspeed.png',
                                    value: _getWeatherForecast(
                                      0,
                                    )['maxWindSpeed'],
                                  ),
                                  WeatherItem(
                                    unit: " %",
                                    imageURL: 'assets/images/humidity.png',
                                    value: _getWeatherForecast(
                                      0,
                                    )['avgHumidity'],
                                  ),
                                  WeatherItem(
                                    unit: " km/h",
                                    imageURL: 'assets/images/lightrain.png',
                                    value: _getWeatherForecast(
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
                                  _getWeatherForecast(
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
                              width: _deviceWidth * .9,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  Card(
                                    elevation: 3.0,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _getWeatherForecast(
                                                  0,
                                                )['forecastDate'],
                                                style: const TextStyle(
                                                  color: Color(0xFF6696F5),
                                                  fontWeight: FontWeight.w600,

                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text("${_getWeatherForecast(0)['minTemperature']}°C",
                                                  style: TextStyle(
                                                    color: AppColors.greyColor,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("${_getWeatherForecast(0)['maxTemperature']}°C",
                                                    style: TextStyle(
                                                      color: AppColors.blackColor,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset('assets/images/${_getWeatherForecast(0)['weatherIcon']}', width: 30,),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(_getWeatherForecast(0)['weatherName'], style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey
                                                  ),)
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('${_getWeatherForecast(0)['chanceOfRain']} %', style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey
                                                  ),),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset('assets/images/lightrain.png', width: 30,),


                                                ],
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3.0,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _getWeatherForecast(
                                                  1,
                                                )['forecastDate'],
                                                style: const TextStyle(
                                                  color: Color(0xFF6696F5),
                                                  fontWeight: FontWeight.w600,

                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text("${_getWeatherForecast(1)['minTemperature']}°C",
                                                    style: TextStyle(
                                                      color: AppColors.greyColor,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("${_getWeatherForecast(1)['maxTemperature']}°C",
                                                    style: TextStyle(
                                                      color: AppColors.blackColor,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset('assets/images/${_getWeatherForecast(1)['weatherIcon']}', width: 30,),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(_getWeatherForecast(1)['weatherName'], style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey
                                                  ),)
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('${_getWeatherForecast(1)['chanceOfRain']} %', style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey
                                                  ),),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset('assets/images/lightrain.png', width: 30,),


                                                ],
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3.0,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _getWeatherForecast(
                                                  2,
                                                )['forecastDate'],
                                                style: const TextStyle(
                                                  color: Color(0xFF6696F5),
                                                  fontWeight: FontWeight.w600,

                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text("${_getWeatherForecast(2)['minTemperature']}°C",
                                                    style: TextStyle(
                                                      color: AppColors.greyColor,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("${_getWeatherForecast(2)['maxTemperature']}°C",
                                                    style: TextStyle(
                                                      color: AppColors.blackColor,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset('assets/images/${_getWeatherForecast(2)['weatherIcon']}', width: 30,),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(_getWeatherForecast(2)['weatherName'], style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey
                                                  ),)
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('${_getWeatherForecast(2)['chanceOfRain']} %', style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey
                                                  ),),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset('assets/images/lightrain.png', width: 30,),


                                                ],
                                              ),
                                            ],
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
