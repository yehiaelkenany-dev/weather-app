import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF6B9DFC);
  static const secondaryColor = Color(0xFFA1C6FD);
  static const tertiaryColor = Color(0xFF205CF1);
  static const blackColor = Color(0xFF1A1D26);

  static const greyColor =  Color(0xFFD9DADB);

  final Shader shader = const LinearGradient(colors: <Color>[Color(0xFFABCFF2), Color(0xFF9AC6F3)]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static const linearGradientBlue =  LinearGradient(begin: Alignment.bottomRight,
  end: Alignment.topLeft,
    colors: [Color(0xFF6B9DFC), Color(0xFF205CF1),],
    stops: [0.0, 1.0],
  );

  static const linearGradientPurple =  LinearGradient(begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xFF51087E), Color(0xFF6C0BA9),],
    stops: [0.0, 1.0],
  );
}

class AppConstants {
  static const String apiKey = '8191b4eec2f44ea0bef133713252805';
  static const String baseUrl = 'https://api.weatherapi.com/v1';
}