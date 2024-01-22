import 'package:flutter/material.dart';
import 'package:iluminaphb/components/request_item.dart';
import 'package:iluminaphb/models/service_request.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:provider/provider.dart';

class RequestListPage extends StatefulWidget {
  final String telaSolicitante;
  const RequestListPage({super.key, required this.telaSolicitante});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  bool _isSearching = false;
  late List<ServiceRequest> _filteredRequests = [];

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

  List<ServiceRequest> _filterRequests(String? searchText) {
    if (widget.telaSolicitante == 'TelaFuncionario') {
      return Provider.of<RequestList>(context, listen: false)
          .getAllItensPorEnderecoAndStatusSolicitacao(
        searchText ?? '',
        'ABERTO',
      );
    } else {
      return Provider.of<RequestList>(context, listen: false)
          .getUserItensPorEndereco(searchText ?? '');
    }
  }

  void _updateFilteredRequests() {
    setState(() {
      _filteredRequests = _filterRequests(_searchText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final RequestList solicitacoes = Provider.of<RequestList>(context);
    final List<ServiceRequest> solicitacoesAbertas =
        Provider.of<RequestList>(context)
            .userItens
            .where((element) => element.status == 'ABERTO')
            .toList();

    final largura = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // actionsIconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  filled: false,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                  hintText: 'Pesquisar por endereço',
                ),
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: (value) {
                  setState(() {
                    _searchText = _searchController.text;
                    _updateFilteredRequests();
                  });
                },
              )
            : Text(
                'Minhas Solicitações',
                style: Theme.of(context).textTheme.bodySmall,
              ),
        centerTitle: true,
        actions: [
          if (!_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: const Icon(Icons.search),
            ),
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _searchText = _searchController.text;
                  _isSearching = !_isSearching;
                  _updateFilteredRequests();
                  _searchController.text = '';
                });
              },
              icon: const Icon(Icons.check),
            ),
        ],
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
                    : _filteredRequests.isEmpty
                        ? _searchText.isNotEmpty
                            ? Text(
                                'Nenhum item com endereço contendo "$_searchText"',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              )
                            : ListView.builder(
                                itemCount:
                                    widget.telaSolicitante == 'TelaFuncionario'
                                        ? solicitacoesAbertas.length
                                        : solicitacoes.userItens.length,
                                itemBuilder: (ctx, index) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        width: largura * 0.95,
                                        child: RequestItem(
                                          request: widget.telaSolicitante ==
                                                  'TelaFuncionario'
                                              ? solicitacoesAbertas[index]
                                              : solicitacoes.userItens[index],
                                          telaSolicitante:
                                              widget.telaSolicitante,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                        : ListView.builder(
                            itemCount: _filteredRequests.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: largura * 0.95,
                                    child: RequestItem(
                                      request: _filteredRequests[index],
                                      telaSolicitante: widget.telaSolicitante,
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
