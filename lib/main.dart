import 'package:flutter/material.dart';
import 'package:she_dull/pages/todo.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            toolbarHeight: 70,
            titleTextStyle: TextStyle(
              fontSize: 32,
            )),
        colorScheme: const ColorScheme(
          background: Colors.black,
          brightness: Brightness.dark,
          primary: Colors.white54,
          onPrimary: Colors.white54,
          secondary: Colors.white54,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.red,
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        brightness: Brightness.dark,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white12,
        ),
      ),
      home: const Todo(),
    );
  }
}
