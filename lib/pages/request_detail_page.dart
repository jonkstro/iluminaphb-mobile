import 'package:flutter/material.dart';
import 'package:iluminaphb/models/request.dart';

class RequestDetailPage extends StatelessWidget {
  final Request request;
  const RequestDetailPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final String endereco =
        '${request.rua}, Nº ${request.numero}, ${request.bairro}';
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
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Text('Detalhes da requisição do endereço: $endereco'),
    );
  }
}
