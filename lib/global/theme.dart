import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: const Color.fromARGB(255, 66, 33, 99),
    onPrimary: MyColors.light,
    surface: MyColors.light,
    onSurface: MyColors.dark,
    secondary: MyColors.light,
    onSecondary: const Color.fromARGB(255, 5, 5, 5),
    error: const Color.fromARGB(255, 222, 62, 95),
    onError: MyColors.light,
    brightness: Brightness.light,
  ),
  textTheme: TextTheme(
    titleMedium: TextStyle(
      fontSize: 40,
      color: const Color.fromARGB(255, 5, 5, 5),
      // fontFamily: "Inter",
    ),
    displayMedium: TextStyle(
      fontSize: 55,
      color: MyColors.light,
      fontFamily: "Archivo Narrow",
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: const Color.fromARGB(255, 66, 33, 99),
    onPrimary: MyColors.light,
    surface: MyColors.gray2,
    onSurface: MyColors.light,
    secondary: const Color.fromARGB(255, 66, 33, 99),
    onSecondary: MyColors.light,
    error: const Color.fromARGB(255, 222, 62, 95),
    onError: MyColors.light,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    titleMedium: TextStyle(
      fontSize: 40,
      color: const Color.fromARGB(255, 249, 249, 249),
      // fontFamily: "Inter",
    ),
    displayMedium: TextStyle(
      fontSize: 55,
      color: const Color.fromARGB(255, 249, 249, 249),
      // fontFamily: "Archivo Narrow",
    ),
  ),
);
