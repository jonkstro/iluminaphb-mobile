// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iluminaphb/models/service_request.dart';

import '../exceptions/http_exception.dart';
import '../utils/constantes.dart';
import 'service_order.dart';

class ServiceOrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<ServiceOrder> _itens = [];
  // Inicializar vazio, caso não receba nenhum parametro
  ServiceOrderList([
    this._token = '',
    this._userId = '',
    this._itens = const [],
  ]);

  // Getter para obter uma cópia imutável da lista de Requests.
  List<ServiceOrder> get itens {
    return [..._itens];
  }

  // Getter para receber a contagem de itens
  int get qtdItens {
    return _itens.length;
  }

  List<ServiceOrder> getAllItensPorNumeroAndEnderecoAndStatusSolicitacao(
    String textoBusca,
    String statusSolicitacao,
  ) {
    return _itens.where((serviceOrder) {
      final String enderecoReq =
          '${serviceOrder.request.rua}, ${serviceOrder.request.numero}, ${serviceOrder.request.bairro}';
      return (serviceOrder.numero.contains(textoBusca) ||
              enderecoReq.toLowerCase().contains(textoBusca.toLowerCase())) &&
          serviceOrder.request.status == statusSolicitacao;
    }).toList();
  }

  Future<void> loadServiceOrders() async {
    // Limpar os itens antes de carregar:
    _itens.clear();
    final response = await http.get(
      Uri.parse('${Constantes.DATABASE_URL}/ordens-servico.json?auth=$_token'),
    );
    // Vai dar dump se o Firebase tiver vazio, pois vai retornar 'Null'
    if (response.body == 'null') return;
    // Adicionar localmente o valor que vai vir de resposta do firebase
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((serviceOrderId, serviceOrderData) {
      _itens.add(
        ServiceOrder(
          id: serviceOrderId,
          numero: serviceOrderData['numero'],
          nomeEncarregado: serviceOrderData['nomeEncarregado'],
          nomeEquipe: serviceOrderData['nomeEquipe'],
          numeroAPR: serviceOrderData['numeroAPR'],
          placaViatura: serviceOrderData['placaViatura'],
          kmViatura: serviceOrderData['kmViatura'],
          dataOrdemServico: serviceOrderData['dataOrdemServico'],
          request: ServiceRequest(
            id: serviceOrderData['request']['id'],
            rua: serviceOrderData['request']['rua'],
            bairro: serviceOrderData['request']['bairro'],
            numero: serviceOrderData['request']['numero'],
            pontoReferencia: serviceOrderData['request']['pontoReferencia'],
            informacaoAdicional: serviceOrderData['request']
                ['informacaoAdicional'],
            tipoSolicitacao: serviceOrderData['request']['tipoSolicitacao'],
            status: serviceOrderData['request']['status'],
            dataSolicitacao: serviceOrderData['request']['dataSolicitacao'],
            nomeSolicitante: serviceOrderData['request']['nomeSolicitante'],
            userId: serviceOrderData['request']['userId'],
          ),
        ),
      );
    });
  }

  // Adicionar a ordem de serviço com base no formData do formulario de OS's
  Future<void> saveServiceOrder(
    ServiceRequest req,
    Map<String, Object> data,
  ) async {
    // verificar se já tem algum id no produto passado, se já tiver um id, vai atualizar
    // ao invés de adicionar novo produto na memória/BD
    bool hasId = data['id'] != null;
    // Aguardar a geração do numero da ordem de serviços
    final String numeroOrdemServico = await _gerarNumeroOrdemServico();
    final serviceOrder = ServiceOrder(
      // Tem ID? Se sim vai receber o mesmo ID, senão vai ser gerado um novo aleatório [só pra preencher, depois pega o do firebase]
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      numero: hasId ? data['numero'] as String : numeroOrdemServico,
      nomeEncarregado: data['nomeEncarregado'] as String,
      nomeEquipe: data['nomeEquipe'] as String,
      numeroAPR: data['numeroAPR'] as String,
      placaViatura: data['placaViatura'] as String,
      kmViatura: data['kmViatura'] as String,
      dataOrdemServico: DateTime.now().toIso8601String(),
      request: req,
    );
    if (hasId) {
      // Vai retornar um Future<void> do método que tá chamando
      return updateServiceOrder(serviceOrder, req);
    } else {
      // Vai retornar um Future<void> do método que tá chamando
      return addServiceOrder(serviceOrder, req);
    }
  }

  // Adicionar no firebase e localmente a solicitação criada acima
  Future<void> addServiceOrder(
      ServiceOrder serviceOrder, ServiceRequest req) async {
    final response = await http.post(
      Uri.parse('${Constantes.DATABASE_URL}/ordens-servico.json?auth=$_token'),
      body: jsonEncode({
        'numero': serviceOrder.numero,
        'nomeEncarregado': serviceOrder.nomeEncarregado,
        'nomeEquipe': serviceOrder.nomeEquipe,
        'numeroAPR': serviceOrder.numeroAPR,
        'placaViatura': serviceOrder.placaViatura,
        'kmViatura': serviceOrder.kmViatura,
        'dataOrdemServico': serviceOrder.dataOrdemServico,
        'request': {
          'id': req.id,
          'rua': req.rua,
          'bairro': req.bairro,
          'numero': req.numero,
          'pontoReferencia': req.pontoReferencia,
          'informacaoAdicional': req.informacaoAdicional,
          'tipoSolicitacao': req.tipoSolicitacao,
          // Avançamos o status da solicitação quando criamos a OS dela
          'status': 'ANDAMENTO',
          'dataSolicitacao': req.dataSolicitacao,
          'nomeSolicitante': req.nomeSolicitante,
          'userId': req.userId,
        },
      }),
    );
    // Se der algum erro no backend, vamos reinserir o item removido na mesma posição de antes
    if (response.statusCode >= 400) {
      // vai estourar essa exception personalizada lá no componente product item
      throw HttpException(
        msg: "Não foi possível criar o item: ${response.body}",
        statusCode: response.statusCode,
      );
    }
    // O id criado pelo o firebase tá vindo como 'name'
    final id = jsonDecode(response.body)['name'];
    _itens.add(
      // Adicionar em memória um produto identico ao do firebase
      ServiceOrder(
        id: id,
        numero: serviceOrder.numero,
        nomeEncarregado: serviceOrder.nomeEncarregado,
        nomeEquipe: serviceOrder.nomeEquipe,
        numeroAPR: serviceOrder.numeroAPR,
        placaViatura: serviceOrder.placaViatura,
        kmViatura: serviceOrder.kmViatura,
        dataOrdemServico: serviceOrder.dataOrdemServico,
        request: req,
      ),
    );
    // Notificar aos interessados da atualização
    notifyListeners();
  }

  // Atualizar no firebase e localmente a solicitação criada acima
  Future<void> updateServiceOrder(
    ServiceOrder serviceOrder,
    ServiceRequest req,
  ) async {
    // Se não achar o índice, vai retornar -1
    int index = _itens.indexWhere((element) => element.id == serviceOrder.id);
    if (index >= 0) {
      final response = await http.patch(
        Uri.parse(
            '${Constantes.DATABASE_URL}/ordens-servico/${serviceOrder.id}.json?auth=$_token'),
        body: jsonEncode({
          'numero': serviceOrder.numero,
          'nomeEncarregado': serviceOrder.nomeEncarregado,
          'nomeEquipe': serviceOrder.nomeEquipe,
          'numeroAPR': serviceOrder.numeroAPR,
          'placaViatura': serviceOrder.placaViatura,
          'kmViatura': serviceOrder.kmViatura,
          'dataOrdemServico': serviceOrder.dataOrdemServico,
          // Ver como vai ser pra add a request, já que vai ter que ir json pro FB, deve ter outro jsonEncode?
          // checar como foi feito com os PEDIDOS no app MinhaLoja do curso da udemy
          'request': {
            'id': req.id,
            'rua': req.rua,
            'bairro': req.bairro,
            'numero': req.numero,
            'pontoReferencia': req.pontoReferencia,
            'informacaoAdicional': req.informacaoAdicional,
            'tipoSolicitacao': req.tipoSolicitacao,
            'status': req.status,
            'dataSolicitacao': req.dataSolicitacao,
            'nomeSolicitante': req.nomeSolicitante,
            'userId': req.userId,
          },
        }),
      );
      // Se der algum erro no backend, vamos reinserir o item removido na mesma posição de antes
      if (response.statusCode >= 400) {
        // vai estourar essa exception personalizada lá no componente product item
        throw HttpException(
          msg: "Não foi possível atualizar o item: ${response.body}",
          statusCode: response.statusCode,
        );
      }

      _itens[index] = serviceOrder;
      notifyListeners();
    }
  }

  Future<void> deleteServiceOrder(ServiceOrder serviceOrder) async {
    // Se não achar o índice, vai retornar -1
    int index = _itens.indexWhere((element) => element.id == serviceOrder.id);
    if (index >= 0) {
      final ServiceOrder ordemServico = _itens[index];
      // primeiro vamos remover da lista, pra depois remover do backend. se der problema
      // no backend a gente adiciona o elemento de volta
      _itens.remove(ordemServico);
      notifyListeners();
      final response = await http.delete(
        Uri.parse(
          '${Constantes.DATABASE_URL}/solicitacoes/${ordemServico.id}.json?auth=$_token',
        ),
      );
      // Se der algum erro no backend, vamos reinserir o item removido na mesma posição de antes
      if (response.statusCode >= 400) {
        _itens.insert(index, ordemServico);
        notifyListeners();
        // vai estourar essa exception personalizada lá no componente product item
        throw HttpException(
          msg: "Não foi possível excluir o item: ${response.body}",
          statusCode: response.statusCode,
        );
      }
    }
  }

  // Método privado para gerar o número com base nas ordens existentes
  Future<String> _gerarNumeroOrdemServico() async {
    // Carregar as ordens de serviço
    await loadServiceOrders();
    final agora = DateTime.now();
    final ano = agora.year.toString();
    // PadLeft com '0' garante dois dígitos para o mês adicionando 0 antes
    final mes = agora.month.toString().padLeft(2, '0');

    // Filtrar os itens no mesmo mes e ano
    final ordensNoMesmoPeriodo = _itens.where((ordem) {
      final anoOrdem = DateTime.parse(ordem.dataOrdemServico).year.toString();
      final mesOrdem = DateTime.parse(ordem.dataOrdemServico)
          .month
          .toString()
          .padLeft(2, '0');
      // Retornar true só se tiver o mesmo mes e ano
      return ano == anoOrdem && mes == mesOrdem;
    }).toList();
    // Agora vai pegar o sequencial com base na qtd de ordens no mesmo periodo
    final sequencial =
        (ordensNoMesmoPeriodo.length + 1).toString().padLeft(4, '0');
    return '$ano-$mes-$sequencial';
  }
}
