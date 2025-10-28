import 'package:flutter/material.dart';
import 'widgets/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Low-Cost Housing Configurator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F4),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.green.shade50,
          indicatorColor: Colors.green.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.black),
          ),
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Colors.green),
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.green.shade50,
          selectedIconTheme: const IconThemeData(color: Colors.green),
          unselectedIconTheme: const IconThemeData(color: Colors.black54),
          selectedLabelTextStyle: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelTextStyle: const TextStyle(color: Colors.black54),
        ),
      ),
      home: const MainScaffold(initialIndex: 0),
      routes: {
        '/input': (context) => const MainScaffold(initialIndex: 0),
        '/output': (context) => const MainScaffold(initialIndex: 1),
      },
    ),
  );
}
