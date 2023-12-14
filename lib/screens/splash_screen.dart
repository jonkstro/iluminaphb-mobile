import 'package:flutter/material.dart';
import 'package:iluminaphb/components/login_page.dart';
import 'package:iluminaphb/screens/login_screen.dart';
import 'package:iluminaphb/utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;

  Future<void> _loadData() async {
    // Substitua este bloco pelo código real para carregar seus recursos
    // Isso é apenas uma simulação
    for (var i = 0; i < 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        _progressValue = i / 100.0;
      });
    }

    // Navegue para a próxima tela após o término do carregamento
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.HOME,
      arguments: const LoginScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash-bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Logotipo ou qualquer outra coisa que você queira exibir na splash screen
          // Exemplo: Image.asset('caminho/do/seu/logotipo.png'),
          Container(
            height: 200,
            width: 200,
            color: Colors.transparent,
            child: Image.asset('assets/images/logo.png'),
          ),
          const SizedBox(height: 20),

          // Barra de progresso linear
          Container(
            decoration: null,
            width: 300,
            child: Column(
              children: [
                Text(
                  'IluminaPHB',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 30),
                LinearProgressIndicator(
                  value: _progressValue,
                  minHeight: 10,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(113, 92, 248, 1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
