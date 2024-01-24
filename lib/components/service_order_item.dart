import 'package:flutter/material.dart';
import 'package:iluminaphb/models/service_order.dart';
import 'package:iluminaphb/models/service_order_list.dart';
import 'package:iluminaphb/pages/service_order_detail_page.dart';
import 'package:iluminaphb/pages/service_order_form_page.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';

class ServiceOrderItem extends StatelessWidget {
  final ServiceOrder serviceOrder;
  const ServiceOrderItem({super.key, required this.serviceOrder});

  @override
  Widget build(BuildContext context) {
    final String endereco =
        'Rua ${serviceOrder.request.rua}, Nº ${serviceOrder.request.numero},  ${serviceOrder.request.bairro}';
    return Card(
      elevation: 5,
      color: Theme.of(context).inputDecorationTheme.fillColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: serviceOrder.request.tipoSolicitacao == 'INSTALACAO'
              ? Colors.amberAccent
              : Colors.orangeAccent,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: serviceOrder.request.tipoSolicitacao == 'INSTALACAO'
                ? const Image(
                    image: AssetImage('assets/images/icon-lamp.png'),
                  )
                : const Image(
                    image: AssetImage('assets/images/icon-repair-tools.png'),
                  ),
          ),
        ),
        title: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OS: ${serviceOrder.numero}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                endereco,
                style: Theme.of(context).textTheme.bodySmall,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Defina o número máximo de linhas desejado
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.HOME,
              arguments: ServiceOrderDetailPage(
                ordemServico: serviceOrder,
              ),
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
                onPressed: serviceOrder.request.status != 'ANDAMENTO'
                    ? null
                    : () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.HOME,
                          arguments: ServiceOrderFormPage(
                            solicitacao: serviceOrder.request,
                            req: serviceOrder,
                          ),
                        );
                      },
              ),
              IconButton(
                onPressed: serviceOrder.request.status != 'ANDAMENTO'
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
                            Provider.of<ServiceOrderList>(
                              context,
                              listen: false,
                            ).deleteServiceOrder(serviceOrder);
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
