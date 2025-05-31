import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  const WeatherItem({
    super.key, required this.unit, required this.imageURL, required this.value,
  });
  final String unit;
  final String imageURL;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),

          ),
          child: Image.asset(imageURL),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value.toString() + unit, style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,),
        ),
      ],
    );
  }
}
