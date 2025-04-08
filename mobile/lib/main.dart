import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/theme/app_theme.dart';
import 'package:language_app/theme/button_theme.dart';
import 'package:language_app/theme/color_theme.dart';

final dio = Dio();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(
              colorTheme: ColorTheme.light,
              buttonTheme: CustomButtonTheme.palette(ColorTheme.light))
          .themeData,
      home: HomePage(
        unit: dummyUnits[0],
      ),
    );
  }
}
