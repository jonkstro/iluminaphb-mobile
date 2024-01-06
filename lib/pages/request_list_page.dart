import 'package:flutter/material.dart';
import 'package:iluminaphb/components/request_item.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:provider/provider.dart';

class RequestListPage extends StatelessWidget {
  const RequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestList solicitacoes = Provider.of<RequestList>(context);
    final largura = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // actionsIconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          'Minhas Solicitações',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: solicitacoes.qtdItens,
          itemBuilder: (ctx, index) {
            return Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: largura * 0.95,
                  child: RequestItem(
                    request: solicitacoes.itens[index],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
