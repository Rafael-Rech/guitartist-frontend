import 'package:flutter/material.dart';
// import 'package:tcc/view/home_page.dart';
import 'package:tcc/view/initial_page.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: InitialPage(),
    // home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
