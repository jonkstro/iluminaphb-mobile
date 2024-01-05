import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iluminaphb/data/dummy_data.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/request.dart';
import 'package:iluminaphb/utils/constantes.dart';

class RequestList with ChangeNotifier {
  // Lista interna de solicitações, inicializada com dados fictícios (DUMMY_REQUESTS).
  final List<Request> _itens = DUMMY_REQUESTS;

  /// QUANDO FOR ADICIONAR AUTENTICAÇÃO PRA BUSCAR POR USUÁRIO - INÍCIO
  // final String _token;
  // final String _userId;
  // List<Request> _itens = [];
  // RequestList([
  //   this._token = '',
  //   this._userId = '',
  //   this._itens = const [],
  // ]);
  /// QUANDO FOR ADICIONAR AUTENTICAÇÃO PRA BUSCAR POR USUÁRIO - FINAL

  // Getter para obter uma cópia imutável da lista de Requests.
  List<Request> get itens {
    return [..._itens];
  }

  // Getter para receber a contagem de itens
  int get qtdItens {
    return _itens.length;
  }

  // Adicionar uma solicitação com base no formData da requestForm
  Future<void> saveRequest(Map<String, Object> data) async {
    // verificar se já tem algum id no produto passado, se já tiver um id, vai atualizar
    // ao invés de adicionar novo produto na memória/BD
    bool hasId = data['id'] != null;

    final request = Request(
      // Tem ID? Se sim vai receber o mesmo ID, senão vai ser gerado um novo aleatório
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      rua: data['rua'] as String,
      bairro: data['bairro'] as String,
      numero: int.parse(data['numero'].toString()),
      pontoReferencia: data['pontoReferencia'].toString(),
      informacaoAdicional: data['informacaoAdicional'].toString(),
      tipoSolicitacao: data['tipoSolicitacao'].toString(),
    );

    if (hasId) {
      // Vai retornar um Future<void> do método que tá chamando
      return updateRequest(request);
    } else {
      // Vai retornar um Future<void> do método que tá chamando
      return addRequest(request);
    }
  }

  Future<void> addRequest(Request request) async {
    final response = await http.post(
      Uri.parse('${Constantes.DATABASE_URL}/solicitacoes'),
      body: jsonEncode(
        {
          'rua': request.rua,
          'bairro': request.bairro,
          'numero': request.numero,
          'pontoReferencia': request.pontoReferencia,
          'informacaoAdicional': request.informacaoAdicional,
          'tipoSolicitacao': request.tipoSolicitacao,
        },
      ),
    );
    // O id criado pelo o firebase tá vindo como 'name'
    final id = jsonDecode(response.body)['name'];
    _itens.add(
// Adicionar em memória um produto identico ao do firebase
      Request(
        id: id,
        rua: request.rua,
        bairro: request.bairro,
        numero: request.numero,
        pontoReferencia: request.pontoReferencia,
        informacaoAdicional: request.informacaoAdicional,
        tipoSolicitacao: request.tipoSolicitacao,
      ),
    );
    notifyListeners(); // Atualizar aos interessados
  }

  Future<void> updateRequest(Request request) async {}
}



/**
 // ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  // Não vamos mais iniciar mockado, pois agora vai ser pego do backend
  // final List<Product> _items = dummyProducts;
  List<Product> _items = [];
  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();
  int get itemsCount {
    return items.length;
  }

  // Carregar os produtos do backend. Esse método vai ser chamado na página inicial de
  // produtos: ProductsOverviewPage.
  Future<void> loadProducts() async {
    // limpar a lista de produtos antes de carregar pra evitar que duplique
    _items.clear();

    final response = await http.get(
      Uri.parse(
        '${Constants.BASE_URL}/produtos.json?auth=$_token',
      ),
    );
    // Vai dar dump se vier vazio no firebase
    if (response.body == 'null') return;

    // Vamos pegar os favoritos pelo userId
    final favResponse = await http.get(
      Uri.parse(
        '${Constants.BASE_URL}/userFavorite/$_userId.json?auth=$_token',
      ),
    );
    // Vamos listar os ids dos produtos favoritos marcados pelo userId
    Map<String, dynamic> _favData =
        favResponse.body == null ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final _isFavorite = _favData[productId] ?? false;
      // Vou adicionar na lista vazia os itens do backend que vai ser carregado
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          //Se vier int ele parseia pra double evitando quebrar a aplicação
          price: double.parse(productData['price'].toString()),
          imageUrl: productData['imageUrl'],
          isFavorite: _isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  // Adicionar com base no formData da ProductFormPage
  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      // Vai retornar um Future<void> do método que tá chamando
      return updateProduct(product);
    } else {
      // Vai retornar um Future<void> do método que tá chamando
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    // await vai esperar esse método até receber uma resposa
    final response = await http.post(
      // Obs.: Deve sempre ter ".json" no final senão o FIREBASE dá erro.
      // Outros backend (ex.: sprintboot) precisa não adicionar o ".json" no final.
      Uri.parse('${Constants.BASE_URL}/produtos.json?auth=$_token'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );

    // O id criado pelo o firebase tá vindo como 'name'
    final id = jsonDecode(response.body)['name'];
    _items.add(
      // Adicionar em memória um produto identico ao do firebase
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    // Se não achar o indice ele retorna index = -1
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      // método patch vai atualizar só o que tá sendo passado.
      // testar se o put funciona no backend do spring validando campos vazios
      final response = await http.patch(
        // Obs.: Deve sempre ter ".json" no final senão o FIREBASE dá erro.
        // Outros backend (ex.: sprintboot) precisa não adicionar o ".json" no final.
        Uri.parse(
            '${Constants.BASE_URL}/produtos/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      // se for maior que -1 então é válido, logo atualizará pro product
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    // Se não achar o indice ele retorna index = -1
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      final Product product = _items[index];
      // primeiro vamos remover da lista, pra depois remover do backend. se der problema
      // no backend a gente adiciona o elemento de volta
      _items.remove(product);
      notifyListeners();
      final response = await http.delete(
        // Obs.: Deve sempre ter ".json" no final senão o FIREBASE dá erro.
        // Outros backend (ex.: sprintboot) precisa não adicionar o ".json" no final.
        Uri.parse(
            '${Constants.BASE_URL}/produtos/${product.id}.json?auth=$_token'),
      );

      // Se der algum erro no backend, vamos reinserir o item removido na mesma posição de antes
      if (response.statusCode >= 400) {
        _items.insert(index, product);
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
 */