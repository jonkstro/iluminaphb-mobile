import 'package:flutter/material.dart';
import 'package:iluminaphb/screens/login_screen.dart';
import 'package:iluminaphb/utils/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color _corFundo = Colors.white;
  void _atualizarCorFundo(Brightness brilho) {
    setState(() {
      // A cor de fundo vai atualizar conforme alterar
      _corFundo = brilho == Brightness.dark ? Colors.black : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Vai pegar o tema atual do celular (light/dark mode)
    Brightness brilhoAtual = MediaQuery.of(context).platformBrightness;

    // Atualiza a cor de fundo com base no tema atual
    _atualizarCorFundo(brilhoAtual);

    return Column(
      children: [
        Container(
          child: const Text(
            "Registra user",
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.HOME,
              arguments: const LoginScreen(),
            );
          },
          icon: Icon(
            Icons.visibility_off,
          ),
        ),
      ],
    );
  }
}
