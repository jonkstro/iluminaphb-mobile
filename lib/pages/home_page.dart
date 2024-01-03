import 'package:flutter/material.dart';
import 'package:iluminaphb/enums/tipo_user_enum.dart';
import 'package:iluminaphb/pages/select_service_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';
import 'unknown_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TipoUserEnum _tipoUser = TipoUserEnum.COMUM;

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
    // var tela = ModalRoute.of(context)?.settings.arguments as Widget;
    // Vai pegar o tema atual do celular (light/dark mode)
    Brightness brilhoAtual = MediaQuery.of(context).platformBrightness;

    // Atualiza a cor de fundo com base no tema atual
    _atualizarCorFundo(brilhoAtual);

    // Vai receber se tá logado, se tiver logado vai pra plataforma,
    // senão vai pra tela de login
    Auth auth = Provider.of<Auth>(context);

    return Scaffold(
      /// Deixar o fundo preto ou branco conforme a cor
      backgroundColor: _corFundo,
      // Impede que a tela seja redimensionada ao exibir o teclado
      // resizeToAvoidBottomInset: false,

      body: Stack(children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              // Cor de filtro (pode ser modificada conforme necessário)
              brilhoAtual == Brightness.dark
                  ? Colors.white
                  : const Color.fromRGBO(255, 255, 255, 0.15),
              BlendMode.modulate,
            ),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Colors.purple.shade400,
                    Colors.purple.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Image(
                image: AssetImage("assets/images/top-left.png"),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.0, // Alinha na parte inferior
          left: 0.0, // Alinha à esquerda
          right: 0.0, // Alinha à direita
          child: Center(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                // Cor de filtro (pode ser modificada conforme necessário)
                brilhoAtual == Brightness.dark
                    ? Colors.white
                    : const Color.fromRGBO(255, 255, 255, 0.15),
                BlendMode.modulate,
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.purple.shade400,
                      Colors.purple.shade50,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const Image(
                  image: AssetImage("assets/images/bottom-right.png"),
                ),
              ),
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints.expand(),
          // child: auth.isAuth ? const UnknownPage() : const AuthPage(),
          child: SelectServicePage(tipoUser: _tipoUser),
        ),
      ]),
    );
  }
}
