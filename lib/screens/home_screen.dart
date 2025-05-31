
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_app/api/api.dart';
import 'package:weather_app/constants.dart';

import '../components/weather_item.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppColors appColors = AppColors();
  final TextEditingController _cityController = TextEditingController();
  final _api = Api();
  String location = 'London';
  String weatherIcon = 'heavycloud.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';


  void fetchWeatherData(String searchText) async {
    try {
      var searchResult = await _api.searchLocation(searchText);
      if (searchResult != null && searchResult.isNotEmpty) {
        final Map<String, dynamic> firstLocationData = searchResult[0];


        print(firstLocationData);

        setState(() {
          location = getShortLocationName(firstLocationData['name']);
          print(location);
        });

        var forecastData = await _api.fetchForecast(firstLocationData['name'], 7); // Assuming you want 7 days forecast
        if (forecastData != null) {
          var current = forecastData['current'];
          var forecastday = forecastData['forecast']['forecastday']; // Get the forecast day array
          if (current != null && forecastday != null) {
            setState(() {
              temperature = (current['temp_c'] as double).toInt();
              windSpeed = (current['wind_kph'] as double).toInt();
              humidity = current['humidity'] as int;
              cloud = current['cloud'] as int;           // Explicitly cast to int
              currentWeatherStatus = current['condition']['text'];
              // Get the date string from the first forecast day
              String dateString = forecastday[0]['date']; // e.g., "2025-05-28"

              // Parse the date string into a DateTime object
              DateTime dateTime = DateTime.parse(dateString);
              currentDate = DateFormat('EEEE, d MMMM yyyy').format(dateTime);

              hourlyWeatherForecast = forecastday[0]['hour'];
              dailyWeatherForecast = forecastday;
              // weatherIcon = forecastData['current']['condition']['icon'];
              print(dailyWeatherForecast);
              print(forecastData);
              print(current);
              print(currentDate);
              print(currentWeatherStatus);
              weatherIcon = "${currentWeatherStatus.replaceAll(' ', '').toLowerCase()}.png";
              print(weatherIcon);
              print(windSpeed);
            });
          }
        } else {
          print("Failed to load forecast data");
        }

      } else {
        print('No data returned from API.');
      }

    } catch (e) {
      print('Error fetching weather data: $e');

    }
  }

  static String getShortLocationName(String s) {
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
  
  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    final _deviceHeight = MediaQuery.sizeOf(context).height;
    final _deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: AppColors.primaryColor.withValues(alpha: .5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: _deviceHeight * .7,
              decoration: BoxDecoration(
                gradient: AppColors.linearGradientBlue,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: .5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3)
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/menu.png",
                        width: 40,
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/pin.png", width: 20,),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(location, style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),),
                          IconButton(onPressed: () {
                            _cityController.clear();
                            showMaterialModalBottomSheet(context: context, builder: (context) => SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Container(
                                height: _deviceHeight * 0.2,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Divider(
                                        thickness: 3.5,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextField(
                                      onChanged: (searchText) {
                                        fetchWeatherData(searchText);
                                      },
                                      controller: _cityController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.search, color: AppColors.primaryColor,),
                                          suffixIcon: GestureDetector(
                                            onTap: () => _cityController.clear(),
                                            child: Icon(Icons.close, color: AppColors.primaryColor,),
                                          ),
                                          hintText: 'Search city e.g. Cairo',
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.primaryColor,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            );
                          }, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,))
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/profile.png', width: 40, height: 40,),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: Image.asset("assets/images/$weatherIcon"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(temperature.toString(),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = appColors.shader,
                        ),
                        ),
                      ),
                      Text('°C',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = appColors.shader,
                        ),
                      ),
                    ],
                  ),
                  Text(currentWeatherStatus, style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,

                  ),),
                  Text(currentDate, style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,

                  ),),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherItem(
                          value: windSpeed, unit: ' km/h', imageURL: 'assets/images/windspeed.png',),
                        WeatherItem(value: humidity, unit: ' %', imageURL: 'assets/images/humidity.png',),
                        WeatherItem(value: cloud, unit: ' %', imageURL: 'assets/images/cloud.png',),

                      ],
                    ),
                  ),

                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: _deviceHeight * .20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Today', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,

                      ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Make sure dailyWeatherForecast is not empty before navigating,
                          // or handle the empty case gracefully in DetailsScreen.
                          if (dailyWeatherForecast.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  dailyWeatherForecast: dailyWeatherForecast, // <--- Pass the data here!
                                ),
                              ),
                            );
                          } else {
                            // Optionally show a message if data isn't ready
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Weather data not loaded yet. Please wait.')),
                            );
                          }
                        },
                        child: Text('Forecasts',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      itemCount: hourlyWeatherForecast.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final hourlyData = hourlyWeatherForecast[index] as Map<String, dynamic>;

                        // Parse the full time string from the API (e.g., "2025-05-28 14:00")
                        DateTime forecastDateTime = DateTime.parse(hourlyData['time']);

                        // Format to get just the hour (e.g., "14:00" or "2 PM")
                        String formattedTime = DateFormat('h a').format(forecastDateTime); // e.g., "2 PM"

                        // Get temperature for the hour
                        int hourlyTemp = (hourlyData['temp_c'] as double).toInt();

                        // Get icon for the hour
                        String hourlyIcon = "${(hourlyData['condition']['text'] as String).replaceAll(' ', '').toLowerCase()}.png";

                        // Determine if this is the current hour for highlighting
                        bool isCurrentHour = forecastDateTime.hour == DateTime.now().hour;

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(right: 20),
                          width: 65,
                          decoration: BoxDecoration(
                            color: isCurrentHour ? Colors.white : AppColors.primaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: AppColors.primaryColor.withValues(alpha: .5),
                              ),

                            ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedTime.toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Image.asset('assets/images/$hourlyIcon', width: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(hourlyTemp.toString(),
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  ),
                                  Text('°C',
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFeatures: const [
                                        FontFeature.enable('subs'),
                                      ],
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                        );
                      },
                    ),
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

