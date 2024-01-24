import 'package:flutter/material.dart';
import 'package:iluminaphb/models/service_order.dart';
import 'package:iluminaphb/models/service_order_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/adaptative_button.dart';

class ServiceOrderDetailPage extends StatelessWidget {
  final ServiceOrder ordemServico;
  const ServiceOrderDetailPage({super.key, required this.ordemServico});

  @override
  Widget build(BuildContext context) {
    final String dataString = ordemServico.request.dataSolicitacao;
    final String dataFormatada =
        DateFormat('dd/MM/yyyy').format(DateTime.tryParse(dataString)!);
    final String endereco =
        '${ordemServico.request.rua}, Nº ${ordemServico.request.numero}, ${ordemServico.request.bairro}';
    Map<String, String> statusCode = {
      'ABERTO': 'Aguardando atendimento',
      'ANDAMENTO': 'Em andamento',
      'CONCLUIDO': 'Concluída',
    };
    Widget createTextRow(String texto1, String texto2) {
      return Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$texto1: ',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              texto2,
              style: Theme.of(context).textTheme.labelSmall,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 4, // Defina o número máximo de linhas desejado
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          'Detalhes da solicitação',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            width: 600,
            decoration: BoxDecoration(
              border: Border.all(width: .5),
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ordemServico.request.tipoSolicitacao == 'INSTALACAO'
                        ? Colors.amberAccent
                        : Colors.orangeAccent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: ordemServico.request.tipoSolicitacao ==
                                'INSTALACAO'
                            ? const Image(
                                image:
                                    AssetImage('assets/images/icon-lamp.png'),
                              )
                            : const Image(
                                image: AssetImage(
                                    'assets/images/icon-repair-tools.png'),
                              ),
                      ),
                      Expanded(
                        child: Text(
                          'Ordem de Serviço: \n${ordemServico.numero}',
                          style: Theme.of(context).textTheme.labelLarge,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          onPressed: ordemServico.request.status != 'ANDAMENTO'
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .inputDecorationTheme
                                            .fillColor,
                                        title: const Text(
                                            'Tem certeza que quer excluir?'),
                                        content: Text(
                                          'Quer realmente excluir a solicitação?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Não',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            onPressed: () {
                                              // Fechar a tela de popup voltando false.
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Sim',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            onPressed: () {
                                              // Fechar a tela de popup voltando true.
                                              Navigator.of(context).pop(true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ).then(
                                    (value) {
                                      // Se fechar o popup voltando true (apertando em SIM)
                                      if (value == true) {
                                        // Se for excluir vai chamar o deleteRequest do provider
                                        // Obs.: O listen tem que tar igual false, pra não quebrar tudo!!!
                                        Provider.of<ServiceOrderList>(
                                          context,
                                          listen: false,
                                        ).deleteServiceOrder(ordemServico);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  );
                                },
                          icon: const Icon(
                            Icons.delete,
                            size: 30,
                          ),
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                createTextRow('EQUIPE DESIGNADA', ordemServico.placaViatura),
                createTextRow(
                  'STATUS DA SOLICITAÇÃO',
                  statusCode[ordemServico.request.status]!,
                ),
                createTextRow('DATA DA SOLICITAÇÃO', dataFormatada),
                createTextRow(
                    'SOLICITANTE', ordemServico.request.nomeSolicitante),
                createTextRow('ENDERECO', endereco),
                createTextRow('PONTO DE REFERÊNCIA',
                    ordemServico.request.pontoReferencia),
                createTextRow('INFORMAÇÕES ADICIONAIS',
                    ordemServico.request.informacaoAdicional),

                /// TODO: Criar botão que vai abrir o Google Maps
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                  child: AdaptativeButton(
                    texto: 'Finalizar a OS',

                    /// TODO:
                    /// - Criar formulário que vai encerrar a OS.
                    /// - Criar as models que vão receber os materiais e servicos
                    /// - Criar o ChangeNotifier e adicionar no backend
                    /// - Criar junto do dummy_data os itens que vão aparecer nos checkboxes
                    onPressed: () {
                      // Navigator.of(context).pushNamed(
                      //   AppRoutes.HOME,
                      //   arguments: ServiceOrderFormPage(
                      //     solicitacao: request,
                      //   ),
                      // );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
