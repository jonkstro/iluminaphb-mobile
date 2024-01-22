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

  Future<void> loadServiceOrders() async {
    // Limpar os itens antes de carregar:
    _itens.clear();
    final response = await http.get(
      Uri.parse('${Constantes.DATABASE_URL}/ordens-servico.json?auth=$_token'),
    );
    // Vai dar dump se o Firebase tiver vazio, pois vai retornar 'Null'
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((serviceOrderId, serviceOrderData) {
      /**
        _itens.add(Request(
        id: solicitacaoId,
        rua: solicitacaoData['rua'],
        bairro: solicitacaoData['bairro'],
        numero: solicitacaoData['numero'],
        pontoReferencia: solicitacaoData['pontoReferencia'],
        informacaoAdicional: solicitacaoData['informacaoAdicional'],
        tipoSolicitacao: solicitacaoData['tipoSolicitacao'],
        status: solicitacaoData['status'],
        dataSolicitacao: solicitacaoData['dataSolicitacao'],
        nomeSolicitante: solicitacaoData['nomeSolicitante'],
        userId: solicitacaoData['userId'],
      ));
       */
    });

    // Adicionar a ordem de serviço com base no formData do formulario de OS's
    Future<void> saveServiceOrder(
        ServiceRequest req, Map<String, Object> data) async {
      // verificar se já tem algum id no produto passado, se já tiver um id, vai atualizar
      // ao invés de adicionar novo produto na memória/BD
      bool hasId = data['id'] != null;
      final serviceOrder = ServiceOrder(
        // Tem ID? Se sim vai receber o mesmo ID, senão vai ser gerado um novo aleatório [só pra preencher, depois pega o do firebase]
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        // TODO: Refazer com a funcao de gerar numero
        numero: data['numero'] as String,
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
        // Ver como vai ser pra add a request, já que vai ter que ir json pro FB, deve ter outro jsonEncode?
        // checar como foi feito com os PEDIDOS no app MinhaLoja do curso da udemy
        'request': req,
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

  Future<void> updateServiceOrder(
      ServiceOrder serviceOrder, ServiceRequest req) async {
    /**
     // Se não achar o índice, vai retornar -1
    int index = _itens.indexWhere((element) => element.id == request.id);
    if (index >= 0) {
      final response = await http.patch(
        Uri.parse(
            '${Constantes.DATABASE_URL}/solicitacoes/${request.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            'rua': request.rua,
            'bairro': request.bairro,
            'numero': request.numero,
            'pontoReferencia': request.pontoReferencia,
            'informacaoAdicional': request.informacaoAdicional,
          },
        ),
      );

      // Se der algum erro no backend, vamos reinserir o item removido na mesma posição de antes
      if (response.statusCode >= 400) {
        // vai estourar essa exception personalizada lá no componente product item
        throw HttpException(
          msg: "Não foi possível atualizar o item: ${response.body}",
          statusCode: response.statusCode,
        );
      }

      _itens[index] = request;
      notifyListeners();
    }
     */
  }
}
/**
 int _ultimoNumeroSequencial = 0;

  String gerarNumeroSequencial() {
    // Obter a data atual no formato ano-mes
    String anoMes = DateFormat('yyyy-MM').format(DateTime.now());

    // Incrementar o número sequencial
    _ultimoNumeroSequencial++;

    // Formatando o número sequencial para ter pelo menos 4 dígitos
    String numeroSequencialFormatado =
        _ultimoNumeroSequencial.toString().padLeft(4, '0');

    // Criar o número sequencial completo
    String numeroCompleto = '$anoMes-$numeroSequencialFormatado';

    return numeroCompleto;
  }

 */