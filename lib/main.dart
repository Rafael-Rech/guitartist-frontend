import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:tcc/view/home_page.dart';
import 'package:tcc/view/splash_screen_page.dart';
import 'package:tcc/global/theme.dart' as my_theme;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    home: const SplashScreenPage(),
    // home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: my_theme.lightTheme,
    darkTheme: my_theme.darkTheme,
  ));
}
