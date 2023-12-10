import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
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
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
            minimumSize: const Size(double.infinity, 80),
            // Cor de fundo do botão
            backgroundColor: const Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 16 * MediaQuery.of(context).textScaleFactor,
            color: isDarkMode
                ? Colors.white
                : const Color.fromRGBO(113, 92, 248, 1),
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
            color: isDarkMode
                ? Colors.white
                : const Color.fromRGBO(113, 92, 248, 1),
          ),
          bodySmall: TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 20 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.normal,
            color: isDarkMode
                ? Colors.white
                : const Color.fromRGBO(113, 92, 248, 1),
          ),
        ),
      ),
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
