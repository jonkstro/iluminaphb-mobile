import 'package:flutter/material.dart';
<<<<<<< HEAD
// import 'package:flutter/services.dart';
import 'package:iluminaphb/components/login_page.dart';

=======
import 'package:iluminaphb/screens/home_screen.dart';
// import 'package:flutter/services.dart';
import 'package:iluminaphb/screens/login_screen.dart';
import 'package:iluminaphb/screens/register_screen.dart';
import 'package:iluminaphb/screens/splash_screen.dart';
import 'package:iluminaphb/utils/app_routes.dart';

/**
 * TODO:
 * 1 - Adicionar os routes pelo utils [andamento]
 * 2 - Criar as telas dentro de screen pasta [ok]
 * 3 - Criar o campo de senha como função? [ok]
 * 4 - As screens vão receber a cor no Scaffold56123456789jonascastro
 */
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
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
<<<<<<< HEAD
      title: 'Flutter Demo',
=======
      color: Colors.blue,
      // title: 'Flutter Demo',
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
<<<<<<< HEAD
            minimumSize: const Size(double.infinity, 80),
=======
            minimumSize: const Size(240, 80),
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
            // Cor de fundo do botão
            backgroundColor: const Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
<<<<<<< HEAD
=======
          
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 16 * MediaQuery.of(context).textScaleFactor,
            color: isDarkMode
<<<<<<< HEAD
                ? Colors.white
=======
                ? const Color.fromRGBO(251, 251, 251, 1)
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
                : const Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
<<<<<<< HEAD
            fontFamily: 'RadiateSans',
            // Se for tablet vai aumentar a fonte
            fontSize: 40 * MediaQuery.of(context).textScaleFactor,
            // fontSize:
            //     MediaQuery.of(context).size.shortestSide < 600 ? 20.0 : 40.0,
=======
            fontFamily: 'Compiler',
            // Se for tablet vai aumentar a fonte
            fontSize: 40 * MediaQuery.of(context).textScaleFactor,
            // fontWeight: FontWeight.bold,
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
          ),
          headlineMedium: TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 40 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold,
            color: isDarkMode
<<<<<<< HEAD
                ? Colors.white
=======
                ? const Color.fromRGBO(251, 251, 251, 1)
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
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
<<<<<<< HEAD
      home: const MyHomePage(
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

    return Stack(children: <Widget>[
      const Positioned(
        top: 0,
        left: 0,
        child: Image(
          image: AssetImage("assets/images/top-left.png"),
        ),
      ),
      const Positioned(
        bottom: 0.0, // Alinha na parte inferior
        left: 0.0, // Alinha à esquerda
        right: 0.0, // Alinha à direita
        child: Center(
          child: Image(
            image: AssetImage("assets/images/bottom-right.png"),
          ),
        ),
      ),
      Container(
        constraints: const BoxConstraints.expand(),
        child: const LoginPage(),
      ),
    ]);
  }

  void _atualizarCorFundo(Brightness brilho) {
    setState(() {
      // A cor de fundo vai atualizar conforme alterar
      _corFundo = brilho == Brightness.dark ? Colors.black : Colors.white;
    });
  }
}
=======
      home: const SplashScreen(),
      routes: {
        AppRoutes.LOGIN_USER: (context) => const LoginScreen(),
        AppRoutes.REGISTER_USER: (context) => const RegisterScreen(),
        AppRoutes.HOME: (context) => const HomeScreen(),
      },
      
    );
  }
}
>>>>>>> 26894029cca3a3686585cd15c44401eab05411e0
