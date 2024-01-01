import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constantes.dart';
import '../exceptions/auth_exception.dart';

/// Obs.: Utilizando API do Firebase para autenticação:
/// https://firebase.google.com/docs/reference/rest/auth?hl=pt
class Auth with ChangeNotifier {
  // Variáveis que irão vir na resposta do Firebase
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;

  // Getter que vai dizer se o user tá autenticado ou não
  bool get isAuth {
    // Validar se a data de expiração tá depois de data de agora, senão bota false
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    // Retorna true se tiver isValid e o token diferente de vazio
    return _token != null && isValid;
  }

  // Getter do token, só vai retornar o token se o user tiver autenticado
  String? get token {
    return isAuth ? _token : null;
  }

  // Getter do email, só vai retornar o email se o user tiver autenticado
  String? get email {
    return isAuth ? _email : null;
  }

  // Getter do userId (id do usuário), só vai retornar o userId se o user tiver autenticado
  String? get userId {
    return isAuth ? _userId : null;
  }

  // Esse método vai servir pra fazer as requisições de signup e signin
  Future<void> _authenticate(
    String email,
    String password,
    String urlFragment,
  ) async {
    // URL que vai autenticar para sigin ou signup a depender do urlFragment
    final String url =
        '${Constantes.AUTH_URL}$urlFragment?key=${Constantes.CHAVE_PROJETO}';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final body = jsonDecode(response.body);
    print(body);
    if (body['error'] != null) {
      // Se retornar erro no response da requisição:
      throw AuthException(key: body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      // O Firebase só traz os segundos que valem o token, então vamos adicionar na data
      // de agora os segundos que ele retornou no response.
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      notifyListeners(); // Atualizar aos interessados
    }
  }

  // Registrar um novo user
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  // Logar um user já existente
  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}