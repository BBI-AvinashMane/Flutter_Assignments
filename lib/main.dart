import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile_page_userinterface/MyHomePage.dart';


void main() {
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal portrait
    DeviceOrientation.landscapeLeft, // Landscape (left)
    DeviceOrientation.landscapeRight, 
    DeviceOrientation.portraitDown,// Landscape (right)
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Profile page'),
    );
  }
}



