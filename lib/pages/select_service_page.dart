import 'package:flutter/material.dart';
import 'package:iluminaphb/enums/tipo_user_enum.dart';

class SelectServicePage extends StatelessWidget {
  final TipoUserEnum tipoUser;
  const SelectServicePage({super.key, required this.tipoUser});

  Widget _createButtons(
    String texto,
    Function() onPressed,
    BuildContext context,
  ) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(238, 218, 231, 1),
            Color.fromRGBO(201, 190, 238, 1),
          ],
        ),
      ),
      height: 120,
      width: 480,
      // constraints: const BoxConstraints(minWidth: 240, minHeight: 120),
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // Deixar arredondado igual no container
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          texto,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Vai receber como argumento o tipo de user, e, a depender do tipo de user, vai ter um comportamento
    // TipoUserEnum tipoUser = ModalRoute.of(context)?.settings.arguments as TipoUserEnum;

    // Mapeamento de textos e ações para cada tipo de usuário
    final Map<TipoUserEnum, Map<int, Map<String, dynamic>>> userButtonMap = {
      TipoUserEnum.COMUM: {
        1: {
          'texto': 'Reclamação de lâmpada queimada',
          'acao': () => print('Ação do Botão Comum 1')
        },
        2: {
          'texto': 'Instalar ponto de iluminação na rua',
          'acao': () => print('Ação do Botão Comum 2')
        },
        3: {
          'texto': 'Minhas solicitações',
          'acao': () => print('Ação do Botão Comum 3')
        },
      },
      TipoUserEnum.FUNCIONARIO: {
        1: {
          'texto': 'Solicitações pendentes',
          'acao': () => print('Ação do Botão Funcionário 1')
        },
        2: {
          'texto': 'Ordens de Serviço em andamento',
          'acao': () => print('Ação do Botão Funcionário 2')
        },
        3: {
          'texto': 'Ordens de Serviço concluídas',
          'acao': () => print('Ação do Botão Funcionário 3')
        },
      },
      TipoUserEnum.ADMIN: {
        1: {
          'texto': 'Tornar outro usuário Admin',
          'acao': () => print('Ação do Botão Funcionário 1')
        },
        2: {
          'texto': 'Remover autorizações Admin',
          'acao': () => print('Ação do Botão Funcionário 2')
        },
      },
      // Adicione mais casos conforme necessário
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Olá Jonas,\n   Como podemos lhe ajudar?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (tipoUser == TipoUserEnum.COMUM)
          for (int i = 1; i <= userButtonMap[tipoUser]!.length; i++)
            _createButtons(
              userButtonMap[tipoUser]![i]!['texto'],
              userButtonMap[tipoUser]![i]!['acao'],
              context,
            ),
      ],
    );
  }
}
