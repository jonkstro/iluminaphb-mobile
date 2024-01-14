import 'package:flutter/material.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/request.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:iluminaphb/pages/request_detail_page.dart';
import 'package:iluminaphb/pages/request_form_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';

class RequestItem extends StatelessWidget {
  final Request request;
  const RequestItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final String endereco =
        'Rua ${request.rua}, Nº ${request.numero},  ${request.bairro}';
    return Card(
      elevation: 5,
      color: Theme.of(context).inputDecorationTheme.fillColor,
      // surfaceTintColor: Colors.black,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: request.tipoSolicitacao == 'INSTALACAO'
              ? Colors.amberAccent
              : Colors.orangeAccent,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: request.tipoSolicitacao == 'INSTALACAO'
                ? const Image(
                    image: AssetImage('assets/images/icon-lamp.png'),
                  )
                : const Image(
                    image: AssetImage('assets/images/icon-repair-tools.png'),
                  ),
          ),
        ),
        title: GestureDetector(
          child: Text(
            endereco,
            style: Theme.of(context).textTheme.bodySmall,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Defina o número máximo de linhas desejado
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.HOME,
              arguments: RequestDetailPage(request: request),
            );
          },
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                // Só pode editar a solicitação se o status for igual a ABERTO
                onPressed: request.status != 'ABERTO'
                    ? null
                    : () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.HOME,
                          arguments: RequestFormPage(
                            solicitacao: request,
                            tipoSolicitacao:
                                request.tipoSolicitacao == 'INSTALACAO'
                                    ? TipoSolicitacaoEnum.INSTALACAO
                                    : TipoSolicitacaoEnum.MANUTENCAO,
                          ),
                        );
                      },
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
                              title:
                                  const Text('Tem certeza que quer excluir?'),
                              content: Text(
                                'Quer realmente excluir a solicitação?',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Não',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  onPressed: () {
                                    // Fechar a tela de popup voltando false.
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Sim',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  onPressed: () {
                                    // Fechar a tela de popup voltando true.
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          // Se fechar o popup voltando true (apertando em SIM)
                          if (value == true) {
                            // Se for excluir vai chamar o deleteRequest do provider
                            // Obs.: O listen tem que tar igual false, pra não quebrar tudo!!!
                            Provider.of<RequestList>(
                              context,
                              listen: false,
                            ).deleteRequest(request);
                          }
                        });
                      },
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
