import 'package:flutter/material.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/request.dart';
import 'package:iluminaphb/pages/request_form_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';

class RequestItem extends StatelessWidget {
  final Request request;
  const RequestItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final String endereco =
        '${request.rua}, Nº ${request.numero}, ${request.bairro}';
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
        title: Text(
          endereco,
          style: Theme.of(context).textTheme.bodySmall,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2, // Defina o número máximo de linhas desejado
        ),
        trailing: SizedBox(
          width: 80,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.HOME,
                    arguments: RequestFormPage(
                      solicitacao: request,
                      tipoSolicitacao: request.tipoSolicitacao == 'INSTALACAO'
                          ? TipoSolicitacaoEnum.INSTALACAO
                          : TipoSolicitacaoEnum.MANUTENCAO,
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
              )
            ],
          ),
        ),

        /**
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        // Mudar a cor do material3 que vem azul
                        backgroundColor: Colors.white,
                        title: const Text('Tem certeza que quer excluir?'),
                        content: Text(
                          'Quer realmente excluir o produto ${produto.nome} ?',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Não',
                            ),
                            onPressed: () {
                              // Fechar a tela de popup voltando false.
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Sim',
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
                      // Se for excluir vai chamar o removeProduct do provider
                      // Obs.: O listen tem que tar igual false, pra não quebrar tudo!!!
                      Provider.of<ListaProdutos>(
                        context,
                        listen: false,
                      ).deleteProduto(produto);
                    }
                  });
                },
              ),
            ],
          ),
        ),
         */
      ),
    );
  }
}
