import 'package:flutter/material.dart';
import 'package:iluminaphb/components/adaptative_button.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/auth.dart';
import 'package:iluminaphb/pages/home_page.dart';
import 'package:iluminaphb/pages/service_order_list_page.dart';
import 'package:iluminaphb/pages/service_request_form_page.dart';
import 'package:iluminaphb/pages/service_request_list_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';

class SelectServicePage extends StatefulWidget {
  final String tipoUser;
  const SelectServicePage({super.key, required this.tipoUser});

  @override
  State<SelectServicePage> createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  bool _isLoading = false;

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
    // Mapeamento de textos e ações para cada tipo de usuário
    final Map<String, Map<int, Map<String, dynamic>>> userButtonMap = {
      'COMUM': {
        1: {
          'texto': 'Reclamação de lâmpada queimada',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments: const ServiceRequestFormPage(
                  tipoSolicitacao: TipoSolicitacaoEnum.MANUTENCAO,
                ),
              )
        },
        2: {
          'texto': 'Instalar ponto de iluminação na rua',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments: const ServiceRequestFormPage(
                  tipoSolicitacao: TipoSolicitacaoEnum.INSTALACAO,
                ),
              )
        },
        3: {
          'texto': 'Minhas solicitações',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments: const ServiceRequestListPage(
                  telaSolicitante: 'TelaComum',
                ),
              )
        },
      },
      'FUNCIONARIO': {
        1: {
          'texto': 'Solicitações pendentes',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments: const ServiceRequestListPage(
                  telaSolicitante: 'TelaFuncionario',
                ),
              )
        },
        2: {
          'texto': 'Ordens de Serviço em andamento',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments:
                    const ServiceOrderListPage(telaSolicitante: 'OS-Andamento'),
              )
        },
        3: {
          'texto': 'Ordens de Serviço concluídas',
          'acao': () => Navigator.of(context).pushNamed(
                AppRoutes.HOME,
                arguments:
                    const ServiceOrderListPage(telaSolicitante: 'OS-Concluida'),
              )
        },
      },
      // TODO: Criar telas de Admin e funções de admin no auth model
      'ADMIN': {
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // actionsIconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          'Selecione o que deseja',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
        automaticallyImplyLeading: auth.permissao == 'COMUM' ? false : true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: FittedBox(
                  child: Text(
                    'Olá ${auth.nome?.split(' ')[0]},\n   Como podemos lhe ajudar?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Vamos percorrer o mapping pelo tipo de usuario que tá pegando no construtor
              for (int i = 1; i <= userButtonMap[widget.tipoUser]!.length; i++)
                AdaptativeButton(
                  texto: userButtonMap[widget.tipoUser]![i]!['texto'],
                  onPressed: userButtonMap[widget.tipoUser]![i]!['acao'],
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
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
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
          ),
        ),
      ),
    );
  }
}
