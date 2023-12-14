import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _corFundo = Colors.white;
  void _atualizarCorFundo(Brightness brilho) {
    setState(() {
      // A cor de fundo vai atualizar conforme alterar
      _corFundo = brilho == Brightness.dark ? Colors.black : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Recebe a tela que vai ser exibida através de argumento quando fizer push
    final tela = ModalRoute.of(context)?.settings.arguments as Widget;
    // Vai pegar o tema atual do celular (light/dark mode)
    Brightness brilhoAtual = MediaQuery.of(context).platformBrightness;

    // Atualiza a cor de fundo com base no tema atual
    _atualizarCorFundo(brilhoAtual);

    return Scaffold(
      /// Deixar o fundo preto ou branco conforme a cor
      backgroundColor: _corFundo,
      body: Stack(children: <Widget>[
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
          // TODO: Se já tiver logado, acessar a plataforma. Senão, acessar a pagina de login.
          child: tela,
        ),
      ]),
    );
  }
}
