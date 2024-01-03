import 'package:flutter/material.dart';
import 'package:iluminaphb/models/auth.dart';
import 'package:iluminaphb/pages/splash_page.dart';
import 'package:iluminaphb/pages/unknown_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Vou dizer aqui que não vou deixar a aplicação rodar pro lado.
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    var brilho = MediaQuery.of(context).platformBrightness;
    // Vai ver se a variavel brilho tá igual escuro
    bool isDarkMode = brilho == Brightness.dark;
    var corTextoPadrao = isDarkMode
        ? const Color.fromRGBO(251, 251, 251, 1)
        : const Color.fromRGBO(113, 92, 248, 1);

    return MultiProvider(
      // Criar os Providers que serão utilizados no projeto
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            error: Colors.red.shade900,
          ),
          fontFamily: 'QuickSand',
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
              color: corTextoPadrao,
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
              fontSize: 40 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: corTextoPadrao,
            ),
            headlineSmall: TextStyle(
              fontSize: 30 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? const Color.fromRGBO(255, 255, 255, 0.8)
                  : const Color.fromRGBO(0, 0, 0, 0.8),
            ),
            bodySmall: TextStyle(
              fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.normal,
              color: corTextoPadrao,
            ),
            bodyMedium: TextStyle(
              fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: corTextoPadrao,
            ),
            bodyLarge: TextStyle(
              fontSize: 25 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.normal,
              color: isDarkMode
                  ? const Color.fromRGBO(255, 255, 255, 0.8)
                  : const Color.fromRGBO(0, 0, 0, 0.8),
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
      ),
    );
  }
}
