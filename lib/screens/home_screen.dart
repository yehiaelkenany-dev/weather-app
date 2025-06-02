import 'dart:async';
import 'dart:ui'; // Import for ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_app/constants.dart';
import '../blocs/weather_bloc/weather_bloc.dart';
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
  bool _showBlurOverlay = true;
  Timer? _blurTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherBloc>().add(const FetchWeather('London'));
    });

    _blurTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showBlurOverlay = false;
        });
      }
    });
  }

  void _showCitySearchModal(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
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
              const SizedBox(height: 10),
              TextField(
                onChanged: (searchText) {
                  if (searchText.isNotEmpty) {
                    context.read<WeatherBloc>().add(FetchWeather(searchText));
                    setState(() {
                      _showBlurOverlay = true;
                      _blurTimer?.cancel();
                      _blurTimer = Timer(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _showBlurOverlay = false;
                          });
                        }
                      });
                    });
                  }
                },
                controller: _cityController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                  suffixIcon: GestureDetector(
                    onTap: () => _cityController.clear(),
                    child: Icon(Icons.close, color: AppColors.primaryColor),
                  ),
                  hintText: 'Search city e.g. Cairo',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _blurTimer?.cancel();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    final deviceHeight = MediaQuery
        .sizeOf(context)
        .height;
    final deviceWidth = MediaQuery
        .sizeOf(context)
        .width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoaded && _showBlurOverlay) {
            _blurTimer?.cancel();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _showBlurOverlay = false;
                });
              }
            });
          }
          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
                  color: AppColors.primaryColor.withValues(alpha: .5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        height: deviceHeight * .7,
                        decoration: BoxDecoration(
                          gradient: AppColors.linearGradientBlue,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha: .5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: (state is WeatherLoaded)
                            ? _buildWeatherContent(state, deviceWidth)
                            : _buildPlaceholderContent(),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: deviceHeight * .20,
                        child: (state is WeatherLoaded)
                            ? _buildForecastSection(state)
                            : _buildPlaceholderForecastSection(),
                      ),
                    ],
                  ),
                ),
                if (_showBlurOverlay)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherContent(WeatherLoaded state, double deviceWidth) {
    return Column(
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
                Image.asset("assets/images/pin.png", width: 20),
                const SizedBox(width: 4),
                Text(
                  state.location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () => _showCitySearchModal(context),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/profile.jpg',
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 160,
          child: Image.asset(
              "assets/images/${state.weatherIcon}"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                state.temperature.toString(),
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = appColors.shader,
                ),
              ),
            ),
            Text(
              '°C',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = appColors.shader,
              ),
            ),
          ],
        ),
        Text(
          state.currentWeatherStatus,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
          ),
        ),
        Text(
          state.currentDate,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Divider(
            color: Colors.white70,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeatherItem(
                  value: state.windSpeed,
                  unit: ' km/h',
                  imageURL: 'assets/images/windspeed.png'),
              WeatherItem(
                  value: state.humidity,
                  unit: ' %',
                  imageURL: 'assets/images/humidity.png'),
              WeatherItem(
                  value: state.cloud,
                  unit: ' %',
                  imageURL: 'assets/images/cloud.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastSection(WeatherLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Today',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (state.dailyWeatherForecast.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(
                            dailyWeatherForecast: state.dailyWeatherForecast,
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Weather data not loaded yet. Please wait.')),
                  );
                }
              },
              child: Text(
                'Forecasts',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: state.hourlyWeatherForecast.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final hourlyData =
              state.hourlyWeatherForecast[index] as Map<String, dynamic>;

              DateTime forecastDateTime = DateTime.parse(hourlyData['time']);
              String formattedTime = DateFormat('h a').format(forecastDateTime);
              int hourlyTemp = (hourlyData['temp_c'] as double).toInt();
              String hourlyIcon =
                  "${(hourlyData['condition']['text'] as String).replaceAll(
                  ' ', '').toLowerCase()}.png";
              bool isCurrentHour = forecastDateTime.hour == DateTime
                  .now()
                  .hour;

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
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Image.asset('assets/images/$hourlyIcon', width: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hourlyTemp.toString(),
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '°C',
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 40, height: 40, color: Colors.white.withValues(alpha: 0.3)),
            Row(
              children: [
                Container(
                    width: 20,
                    height: 20,
                    color: Colors.white.withValues(alpha: 0.3)),
                const SizedBox(width: 4),
                Container(
                    width: 80,
                    height: 16,
                    color: Colors.white.withValues(alpha: 0.3)),
                Container(
                    width: 24,
                    height: 24,
                    color: Colors.white.withValues(alpha: 0.3)),
              ],
            ),
            Container(
                width: 40, height: 40, color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
        Container(
            width: 160, height: 160, color: Colors.white.withValues(alpha: 0.3)),
        Container(
            width: 120, height: 80, color: Colors.white.withValues(alpha: 0.3)),
        Container(
            width: 150, height: 20, color: Colors.white.withValues(alpha: 0.3)),
        Container(
            width: 200, height: 20, color: Colors.white.withValues(alpha: 0.3)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 60, height: 60, color: Colors.white.withValues(alpha: 0.3)),
              Container(
                  width: 60, height: 60, color: Colors.white.withValues(alpha: 0.3)),
              Container(
                  width: 60, height: 60, color: Colors.white.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderForecastSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 80,
                height: 20,
                color: Colors.black.withValues(alpha: 0.1)),
            Container(
                width: 100,
                height: 20,
                color: Colors.blue.withValues(alpha: 0.1)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            itemCount: 5, // Show a few placeholder items
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(right: 20),
                width: 65,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 5,
                      color: AppColors.primaryColor.withValues(alpha: .2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 40,
                        height: 17,
                        color: Colors.white.withValues(alpha: 0.3)),
                    Container(
                        width: 20,
                        height: 20,
                        color: Colors.white.withValues(alpha: 0.3)),
                    Container(
                        width: 40,
                        height: 17,
                        color: Colors.white.withValues(alpha: 0.3)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}