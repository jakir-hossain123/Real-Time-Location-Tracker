import 'package:flutter/material.dart';

import 'location_tracker/presentation/map_screen.dart';

void main() {
  runApp(const RealTimeLocationTrackerApp());
}

class MyApp extends RealTimeLocationTrackerApp {
  const MyApp({super.key});
}

class RealTimeLocationTrackerApp extends StatelessWidget {
  const RealTimeLocationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
      ),
      home: const MapScreen(),
    );
  }
}

