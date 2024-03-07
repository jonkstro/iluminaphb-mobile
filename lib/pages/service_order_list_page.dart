import 'package:flutter/material.dart';
import 'package:iluminaphb/components/service_order_item.dart';
import 'package:provider/provider.dart';

import '../models/service_order.dart';
import '../models/service_order_list.dart';

class ServiceOrderListPage extends StatefulWidget {
  final String telaSolicitante;
  const ServiceOrderListPage({super.key, required this.telaSolicitante});

  @override
  State<ServiceOrderListPage> createState() => _ServiceOrderListPageState();
}

class _ServiceOrderListPageState extends State<ServiceOrderListPage> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  bool _isSearching = false;
  List<ServiceOrder> _filteredRequests = [];

  @override
  void initState() {
    super.initState();
    _refreshServiceOrders().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshServiceOrders() {
    return Provider.of<ServiceOrderList>(
      context,
      listen: false,
    ).loadServiceOrders();
  }

  List<ServiceOrder> _filterServiceOrders(String? searchText) {
    return Provider.of<ServiceOrderList>(context, listen: false)
        .getAllItensPorNumeroAndEnderecoAndStatusSolicitacao(
      searchText ?? '',
      'ANDAMENTO',
    );
  }

  void _updateFilteredRequests() {
    setState(() {
      _filteredRequests = _filterServiceOrders(_searchText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ServiceOrderList ordensServico =
        Provider.of<ServiceOrderList>(context);
    final List<ServiceOrder> ordensServicoAndamento = ordensServico.itens
        .where(widget.telaSolicitante == 'OS-Andamento'
            ? (element) => element.request.status == 'ANDAMENTO'
            : (element) => element.request.status == 'CONCLUIDO')
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
                'Ordens de Serviço ${widget.telaSolicitante == 'OS-Andamento' ? 'em Andamento' : 'Concluídas'}',
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
        onRefresh: () => _refreshServiceOrders(),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: ordensServicoAndamento.isEmpty
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
                            // Se tiver vazio pedidos filtrados: Mostrar tudo
                            : ListView.builder(
                                itemCount: ordensServicoAndamento.length,
                                itemBuilder: (ctx, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: largura * 0.95,
                                        child: ServiceOrderItem(
                                          serviceOrder:
                                              ordensServicoAndamento[index],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                        // Senão, mostrar só os filtrados no texto
                        : ListView.builder(
                            itemCount: _filteredRequests.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: largura * 0.95,
                                    child: ServiceOrderItem(
                                      serviceOrder: _filteredRequests[index],
                                    ),
                                  ),
                                ],
                              );
                            },
                          )),
      ),
    );
  }
}
