import 'package:flutter/material.dart';
import 'package:iluminaphb/pages/splash_page.dart';
import 'package:iluminaphb/pages/unknown_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'pages/home_page.dart';

/**
 * TODO:
 * 1 - Adicionar os routes pelo utils [andamento]
 * 2 - Criar as telas dentro de screen pasta [ok]
 * 3 - Criar o campo de senha como função? [ok]
 * 4 - As screens vão receber a cor no Scaffold56123456789jonascastro
 */
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Vou dizer aqui que não vou deixar a aplicação rodar pro lado.
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    var brilho = MediaQuery.of(context).platformBrightness;
    // Vai ver se a variavel brilho tá igual escuro
    bool isDarkMode = brilho == Brightness.dark;

    return MaterialApp(
      color: Colors.blue,
      // title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(240, 80),
            // Cor de fundo do botão
            backgroundColor: const Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: isDarkMode
              ? const Color.fromRGBO(0, 0, 0, 0.8)
              : const Color.fromRGBO(255, 255, 255, 0.8),
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 16 * MediaQuery.of(context).textScaleFactor,
            color: isDarkMode
                ? const Color.fromRGBO(251, 251, 251, 1)
                : const Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Compiler',
            // Se for tablet vai aumentar a fonte
            fontSize: 40 * MediaQuery.of(context).textScaleFactor,
            // fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 40 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? const Color.fromRGBO(251, 251, 251, 1)
                : const Color.fromRGBO(113, 92, 248, 1),
          ),
          bodySmall: TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 20 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.normal,
            color: isDarkMode
                ? const Color.fromRGBO(251, 251, 251, 1)
                : const Color.fromRGBO(113, 92, 248, 1),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 20 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? const Color.fromRGBO(251, 251, 251, 1)
                : const Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
      ),
      // remover aquela lista de debug
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      routes: {
        AppRoutes.HOME: (context) => const HomePage(),
      },
      // Se não achar nenhuma rota vai abrir a "Página 404" igual na WEB
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) {
            return const UnknownPage();
          },
        );
      },
    );
  }
}
