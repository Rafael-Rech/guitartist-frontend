import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:tcc/view/home_page.dart';
import 'package:tcc/view/splash_screen_page.dart';
import 'package:tcc/global/theme.dart' as my_theme;
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: my_theme.lightTheme,
      dark: my_theme.darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        home: const SplashScreenPage(),
        title: "Guitartist",
        debugShowCheckedModeBanner: false,
        theme: my_theme.lightTheme,
        darkTheme: my_theme.darkTheme,
      ),
    );
  }
}
