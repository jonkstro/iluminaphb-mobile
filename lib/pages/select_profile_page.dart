import 'package:flutter/material.dart';
import 'package:iluminaphb/pages/home_page.dart';
import 'package:iluminaphb/pages/select_service_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';

import '../components/adaptative_button.dart';
import '../models/auth.dart';

class SelectProfilePage extends StatefulWidget {
  const SelectProfilePage({super.key});

  @override
  State<SelectProfilePage> createState() => _SelectProfilePageState();
}

class _SelectProfilePageState extends State<SelectProfilePage> {
  bool _isLoading = false;
  int _qtdBotoes = 0;

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    // Vou chamar o Provider que vai zerar as minhas credenciais
    await Provider.of<Auth>(context, listen: false).logout();
    setState(() => _isLoading = false);
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.HOME,
      arguments: HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    String permissao = auth.permissao ?? '';
    if (permissao == 'FUNCIONARIO') {
      setState(() {
        _qtdBotoes = 2;
      });
    } else {
      setState(() {
        _qtdBotoes = 3;
      });
    }

    // Mapeamento de textos e ações para cada tipo de usuário
    final Map<int, Map<String, dynamic>> userButtonMap = {
      1: {
        'texto': 'Acessar tela de usuários comuns',
        'acao': () => Navigator.of(context).pushNamed(
              AppRoutes.HOME,
              arguments: const SelectServicePage(
                tipoUser: 'COMUM',
              ),
            ),
      },
      2: {
        'texto': 'Acessar tela de funcionários',
        'acao': () => Navigator.of(context).pushNamed(
              AppRoutes.HOME,
              arguments: const SelectServicePage(
                tipoUser: 'FUNCIONARIO',
              ),
            ),
      },
      3: {
        'texto': 'Acessar tela de administradores',
        'acao': () => Navigator.of(context).pushNamed(
              AppRoutes.HOME,
              arguments: const SelectServicePage(
                tipoUser: 'ADMIN',
              ),
            ),
      },
    };

    return Center(
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          const SizedBox(height: 80),
          FittedBox(
            child: Text(
              'Olá ${auth.nome?.split(' ')[0]},\n   Como podemos lhe ajudar?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 30),
          // Vamos percorrer o mapping pelo tipo de usuario que tá pegando no construtor

          for (int i = 1; i <= _qtdBotoes; i++)
            AdaptativeButton(
              texto: userButtonMap[i]!['texto'],
              onPressed: userButtonMap[i]!['acao'],
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: _isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.error,
                  )
                : SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        _logout();
                      },
                      child: const Text(
                        'SAIR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      )),
    );
  }
}
