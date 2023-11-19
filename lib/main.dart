// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iluminaphb/components/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 80),
            backgroundColor: // Cor de fundo do botão
                Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          labelStyle: TextStyle(
              fontSize:
                  MediaQuery.of(context).size.shortestSide < 600 ? 16.0 : 22.0),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'RadiateSans',
            // Se for tablet vai aumentar a fonte
            fontSize:
                MediaQuery.of(context).size.shortestSide < 600 ? 20.0 : 40.0,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'QuickSand',
            fontSize:
                MediaQuery.of(context).size.shortestSide < 600 ? 40.0 : 80.0,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(113, 92, 248, 1),
          ),
          bodySmall: TextStyle(
            fontFamily: 'QuickSand',
            fontSize:
                MediaQuery.of(context).size.shortestSide < 600 ? 16.0 : 32.0,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
