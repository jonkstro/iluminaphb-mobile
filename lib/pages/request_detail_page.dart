import 'package:flutter/material.dart';
import 'package:iluminaphb/models/request.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/request_list.dart';

class RequestDetailPage extends StatelessWidget {
  final Request request;
  const RequestDetailPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final String dataString = request.dataSolicitacao;
    final String dataFormatada =
        DateFormat('dd/MM/yyyy').format(DateTime.tryParse(dataString)!);
    final String endereco =
        '${request.rua}, Nº ${request.numero}, ${request.bairro}';
    Map<String, String> statusCode = {
      'ABERTO': 'Aguardando atendimento',
      'ANDAMENTO': 'Em andamento',
      'CONCLUIDO': 'Concluída',
    };
    Widget _createTextRow(String texto1, String texto2) {
      return Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Text(
              '$texto1: ',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              texto2,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // actionsIconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          'Detalhes da solicitação',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(width: .5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: request.tipoSolicitacao == 'INSTALACAO'
                    ? Colors.amberAccent
                    : Colors.orangeAccent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: request.tipoSolicitacao == 'INSTALACAO'
                        ? const Image(
                            image: AssetImage('assets/images/icon-lamp.png'),
                          )
                        : const Image(
                            image: AssetImage(
                                'assets/images/icon-repair-tools.png'),
                          ),
                  ),
                  Text(
                    request.tipoSolicitacao == 'INSTALACAO'
                        ? 'SOLICITAÇÃO DE INSTALAÇÃO'
                        : 'SOLICITAÇÃO DE MANUTENÇÃO',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    onPressed: request.status != 'ABERTO'
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                                  Provider.of<RequestList>(
                                    context,
                                    listen: false,
                                  ).deleteRequest(request);
                                }
                                Navigator.of(context).pop();
                              },
                            );
                          },
                    icon: const Icon(
                      Icons.delete,
                      size: 50,
                    ),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _createTextRow(
              'STATUS DA SOLICITAÇÃO',
              statusCode[request.status]!,
            ),
            _createTextRow('DATA DA SOLICITAÇÃO', dataFormatada),
            _createTextRow('SOLICITANTE', request.nomeSolicitante),
            _createTextRow('ENDERECO', endereco),
            _createTextRow('PONTO DE REFERÊNCIA', request.pontoReferencia),
            _createTextRow(
                'INFORMAÇÕES ADICIONAIS', request.informacaoAdicional),
          ],
        ),
      ),
    );
  }
}
