import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iluminaphb/models/service_request.dart';
import 'package:iluminaphb/utils/constantes.dart';

import '../exceptions/http_exception.dart';

class RequestList with ChangeNotifier {
  // Lista interna de solicitações, inicializada com dados fictícios (DUMMY_REQUESTS).
  // final List<Request> _itens = DUMMY_REQUESTS;

  /// QUANDO FOR ADICIONAR AUTENTICAÇÃO PRA BUSCAR POR USUÁRIO - INÍCIO
  final String _token;
  final String _userId;
  List<ServiceRequest> _itens = [];
  RequestList([
    this._token = '',
    this._userId = '',
    this._itens = const [],
  ]);

  /// QUANDO FOR ADICIONAR AUTENTICAÇÃO PRA BUSCAR POR USUÁRIO - FINAL

  // Getter para obter uma cópia imutável da lista de Requests.
  List<ServiceRequest> get itens {
    return [..._itens];
  }

  // Getter que vai listar só os itens do usuário
  List<ServiceRequest> get userItens {
    // Add status após o userId se não quiser trazer as concs
    return _itens.where((req) => req.userId == _userId).toList();
  }

  List<ServiceRequest> getUserItensPorEndereco(String endereco) {
    return _itens.where((req) {
      final String enderecoReq = '${req.rua}, ${req.numero}, ${req.bairro}';
      return req.userId == _userId &&
          enderecoReq.toLowerCase().contains(endereco.toLowerCase());
    }).toList();
  }

  List<ServiceRequest> getAllItensPorEnderecoAndStatusSolicitacao(
      String endereco, String statusSolicitacao) {
    return _itens.where((req) {
      final String enderecoReq = '${req.rua}, ${req.numero}, ${req.bairro}';
      return enderecoReq.toLowerCase().contains(endereco.toLowerCase()) &&
          req.status == statusSolicitacao;
    }).toList();
  }

  // Getter para receber a contagem de itens
  int get qtdItens {
    return _itens.length;
  }

  Future<void> loadRequests() async {
    // Limpar os itens antes de carregar:
    _itens.clear();

    final response = await http.get(
      Uri.parse('${Constantes.DATABASE_URL}/solicitacoes.json?auth=$_token'),
    );
    // Vai dar dump se o Firebase tiver vazio, pois vai retornar 'Null'
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((solicitacaoId, solicitacaoData) {
      _itens.add(ServiceRequest(
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
    });
  }

  // Adicionar uma solicitação com base no formData da requestForm
  Future<void> saveRequest(Map<String, Object> data) async {
    // verificar se já tem algum id no produto passado, se já tiver um id, vai atualizar
    // ao invés de adicionar novo produto na memória/BD
    bool hasId = data['id'] != null;

    final request = ServiceRequest(
      // Tem ID? Se sim vai receber o mesmo ID, senão vai ser gerado um novo aleatório [só pra preencher, depois pega o do firebase]
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      rua: data['rua'] as String,
      bairro: data['bairro'] as String,
      numero: int.parse(data['numero'].toString()),
      pontoReferencia: data['pontoReferencia'].toString(),
      informacaoAdicional: data['informacaoAdicional'].toString(),
      tipoSolicitacao: data['tipoSolicitacao'].toString(),
      status: 'ABERTO',
      dataSolicitacao: DateTime.now().toIso8601String(),
      nomeSolicitante: data['nomeSolicitante'] as String,
      userId: _userId,
    );

    if (hasId) {
      // Vai retornar um Future<void> do método que tá chamando
      return updateRequest(request);
    } else {
      // Vai retornar um Future<void> do método que tá chamando
      return addRequest(request);
    }
  }

  // Adicionar no firebase e localmente a solicitação criada acima
  Future<void> addRequest(ServiceRequest request) async {
    final response = await http.post(
      Uri.parse('${Constantes.DATABASE_URL}/solicitacoes.json?auth=$_token'),
      body: jsonEncode(
        {
          'rua': request.rua,
          'bairro': request.bairro,
          'numero': request.numero,
          'pontoReferencia': request.pontoReferencia,
          'informacaoAdicional': request.informacaoAdicional,
          'tipoSolicitacao': request.tipoSolicitacao,
          'status': request.status,
          'dataSolicitacao': request.dataSolicitacao,
          'nomeSolicitante': request.nomeSolicitante,
          'userId': request.userId,
        },
      ),
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
      ServiceRequest(
        id: id,
        rua: request.rua,
        bairro: request.bairro,
        numero: request.numero,
        pontoReferencia: request.pontoReferencia,
        informacaoAdicional: request.informacaoAdicional,
        tipoSolicitacao: request.tipoSolicitacao,
        status: request.status,
        dataSolicitacao: request.dataSolicitacao,
        nomeSolicitante: request.nomeSolicitante,
        userId: _userId,
      ),
    );
    notifyListeners(); // Atualizar aos interessados
  }

  Future<void> updateRequest(ServiceRequest request) async {
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
  }

  Future<void> deleteRequest(ServiceRequest request) async {
    // Se não achar o índice, vai retornar -1
    int index = _itens.indexWhere((element) => element.id == request.id);
    if (index >= 0) {
      final ServiceRequest solicitacao = _itens[index];
      // primeiro vamos remover da lista, pra depois remover do backend. se der problema
      // no backend a gente adiciona o elemento de volta
      _itens.remove(solicitacao);
      notifyListeners();
      final response = await http.delete(
        // Obs.: Deve sempre ter ".json" no final senão o FIREBASE dá erro.
        // Outros backend (ex.: sprintboot) precisa não adicionar o ".json" no final.
        Uri.parse(
            // '${Constants.BASE_URL}/produtos/${product.id}.json?auth=$_token'),
            '${Constantes.DATABASE_URL}/solicitacoes/${solicitacao.id}.json?auth=$_token'),
      );
      // Se der algum erro no backend, vamos reinserir o item removido na mesma posição de antes
      if (response.statusCode >= 400) {
        _itens.insert(index, solicitacao);
        notifyListeners();
        // vai estourar essa exception personalizada lá no componente product item
        throw HttpException(
          msg: "Não foi possível excluir o item: ${response.body}",
          statusCode: response.statusCode,
        );
      }
    }
  }
}
