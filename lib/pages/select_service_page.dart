import 'package:flutter/material.dart';
import 'package:iluminaphb/components/adaptative_button.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/enums/tipo_user_enum.dart';
import 'package:iluminaphb/pages/request_form_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';

class SelectServicePage extends StatelessWidget {
  final TipoUserEnum tipoUser;
  const SelectServicePage({super.key, required this.tipoUser});

  @override
  Widget build(BuildContext context) {
    // Vai receber como argumento o tipo de user, e, a depender do tipo de user, vai ter um comportamento
    // TipoUserEnum tipoUser = ModalRoute.of(context)?.settings.arguments as TipoUserEnum;

    // Mapeamento de textos e ações para cada tipo de usuário
    final Map<TipoUserEnum, Map<int, Map<String, dynamic>>> userButtonMap = {
      TipoUserEnum.COMUM: {
        1: {
          'texto': 'Reclamação de lâmpada queimada',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments: const RequestFormPage(
                  tipoSolicitacao: TipoSolicitacaoEnum.MANUTENCAO,
                ),
              )
        },
        2: {
          'texto': 'Instalar ponto de iluminação na rua',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments: const RequestFormPage(
                  tipoSolicitacao: TipoSolicitacaoEnum.INSTALACAO,
                ),
              )
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

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Olá Jonas,\n   Como podemos lhe ajudar?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          // Vamos percorrer o mapping pelo tipo de usuario que tá pegando no construtor
          for (int i = 1; i <= userButtonMap[tipoUser]!.length; i++)
            AdaptativeButton(
              texto: userButtonMap[tipoUser]![i]!['texto'],
              onPressed: userButtonMap[tipoUser]![i]!['acao'],
            ),
        ],
      ),
    );
  }
}
