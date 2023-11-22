// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iluminaphb/components/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Vou dizer aqui que não vou deixar a aplicação rodar pro lado.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    var brilho = MediaQuery.of(context).platformBrightness;
    // Vai ver se a variavel brilho tá igual escuro
    bool isDarkMode = brilho == Brightness.dark;

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
            fontSize: 16 * MediaQuery.of(context).textScaleFactor,
            color: isDarkMode ? Colors.white : Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'RadiateSans',
            // Se for tablet vai aumentar a fonte
            fontSize: 40 * MediaQuery.of(context).textScaleFactor,
            // fontSize:
            //     MediaQuery.of(context).size.shortestSide < 600 ? 20.0 : 40.0,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 40 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Color.fromRGBO(113, 92, 248, 1),
          ),
          bodySmall: TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 20 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.normal,
            color: isDarkMode ? Colors.white : Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
      ),
      home: MyHomePage(
        title: 'IluminaPHB',
      ),
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
  Color _corFundo = Colors.white;

  @override
  Widget build(BuildContext context) {
    // Vai pegar o tema atual do celular (light/dark mode)
    Brightness brilhoAtual = MediaQuery.of(context).platformBrightness;

    // Atualiza a cor de fundo com base no tema atual
    _atualizarCorFundo(brilhoAtual);

    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/app_bg.png"),
            fit: BoxFit.cover,
          ),
          color: _corFundo, // Cor de fundo configurada no setState
        ),
        child: LoginPage());
  }

  void _atualizarCorFundo(Brightness brilho) {
    setState(() {
      // A cor de fundo vai atualizar conforme alterar
      _corFundo = brilho == Brightness.dark ? Colors.black : Colors.white;
    });
  }
}
