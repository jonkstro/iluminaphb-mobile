import 'package:flutter/material.dart';
import 'package:iluminaphb/data/dummy_data.dart';
import 'package:iluminaphb/models/request.dart';

class RequestList with ChangeNotifier {
  // Lista interna de solicitações, inicializada com dados fictícios (DUMMY_REQUESTS).
  final List<Request> _itens = DUMMY_REQUESTS;

  // Getter para obter uma cópia imutável da lista de Requests.
  List<Request> get itens {
    return [..._itens];
  }

  // Getter para receber a contagem de itens
  int get qtdItens {
    return _itens.length;
  }
}
