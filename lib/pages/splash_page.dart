// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iluminaphb/pages/home_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _progressValue = 0.0;

  Future<void> _loadData() async {
    // Substitua este bloco pelo código real para carregar seus recursos
    // Isso é apenas uma simulação
    for (var i = 0; i < 100; i++) {
      await Future.delayed(const Duration(milliseconds: 10));
      setState(() {
        _progressValue = i / 100.0;
      });
    }
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.HOME,
      arguments: HomePage(),
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
                // Deixar as bordas arredondadas
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    minHeight: 10,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(113, 92, 248, 1)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
