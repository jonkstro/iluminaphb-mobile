import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iluminaphb/exceptions/http_exception.dart';
import 'package:iluminaphb/models/service_order_finish.dart';
import 'package:iluminaphb/utils/constantes.dart';

class ServiceOrderFinishList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<ServiceOrderFinish> _itens = [];
  // Inicializar vazio, caso não receba nenhum parametro
  ServiceOrderFinishList([
    this._token = '',
    this._userId = '',
    this._itens = const [],
  ]);

  // Getter para obter uma cópia imutável da lista de Requests.
  List<ServiceOrderFinish> get itens {
    return [..._itens];
  }

  Future<void> finishServiceOrder(ServiceOrderFinish serviceOrderFinish) async {
    final response = await http.post(
        Uri.parse(
            '${Constantes.DATABASE_URL}/materiais-servicos.json?auth=$_token'),
        body: jsonEncode({
          'ordemServico': {
            'id': serviceOrderFinish.ordemServico?.id,
            'numero': serviceOrderFinish.ordemServico?.numero,
            'nomeEncarregado': serviceOrderFinish.ordemServico?.nomeEncarregado,
            'nomeEquipe': serviceOrderFinish.ordemServico?.nomeEquipe,
            'numeroAPR': serviceOrderFinish.ordemServico?.numeroAPR,
            'placaViatura': serviceOrderFinish.ordemServico?.placaViatura,
            'kmViatura': serviceOrderFinish.ordemServico?.kmViatura,
            'dataOrdemServico':
                serviceOrderFinish.ordemServico?.dataOrdemServico,
          },
          'materiais': serviceOrderFinish.materiais
              ?.map(
                (material) => {
                  'id': material.id,
                  'descricao': material.descricao,
                  'quantidade': material.qtd,
                },
              )
              .toList(),
          'servicos': serviceOrderFinish.servicos
              ?.map(
                (servico) => {
                  'id': servico.id,
                  'descricao': servico.descricao,
                  'quantidade': servico.qtd,
                },
              )
              .toList(),
        }));

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
      ServiceOrderFinish(
        id: id,
        ordemServico: serviceOrderFinish.ordemServico,
        materiais: serviceOrderFinish.materiais,
        servicos: serviceOrderFinish.servicos,
      ),
    );
    // Notificar aos interessados da atualização
    notifyListeners();
  }
}
