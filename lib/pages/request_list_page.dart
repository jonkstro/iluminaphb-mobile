import 'package:flutter/material.dart';
import 'package:iluminaphb/components/request_item.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:provider/provider.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<RequestList>(context, listen: false)
        .loadRequests()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> refreshRequests() {
    return Provider.of<RequestList>(context, listen: false).loadRequests();
  }

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
      body: RefreshIndicator(
        onRefresh: () => refreshRequests(),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: solicitacoes.userItens.isEmpty
                    ? Text(
                        'Nenhuma solicitação cadastrada ainda',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      )
                    : ListView.builder(
                        itemCount: solicitacoes.userItens.length,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: largura * 0.95,
                                child: RequestItem(
                                  request: solicitacoes.userItens[index],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
