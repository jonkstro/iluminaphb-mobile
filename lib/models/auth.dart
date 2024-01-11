import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:emailjs/emailjs.dart';
import 'package:iluminaphb/data/storage.dart';
import 'package:iluminaphb/exceptions/email_validation_exception.dart';
import 'package:iluminaphb/exceptions/http_exception.dart';

import '../utils/constantes.dart';
import '../exceptions/auth_exception.dart';

/// Obs.: Utilizando API do Firebase para autenticação:
/// https://firebase.google.com/docs/reference/rest/auth?hl=pt
class Auth with ChangeNotifier {
  // Variáveis que irão vir na resposta do Firebase
  String? _token;
  String? _email;
  String? _userId;
  String? _nome;
  String? _permissao;
  bool? _isAtivo;
  DateTime? _expiryDate;
  String _idUserDetail = '';

  // Getter que vai dizer se o user tá autenticado ou não
  bool get isAuth {
    // Validar se a data de expiração tá depois de data de agora, senão bota false
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    // Retorna true se tiver isValid e o token diferente de vazio
    // adicionado o _isAtivo, pois se não tiver ativo não validou o email
    return _token != null && isValid;
  }

  bool? get isAtivo {
    return isAuth ? _isAtivo : null;
  }

  // Getter do token, só vai retornar o token se o user tiver autenticado
  String? get token {
    return isAuth ? _token : null;
  }

  // Getter do email, só vai retornar o email se o user tiver autenticado
  String? get email {
    return isAuth ? _email : null;
  }

  String? get nome {
    return isAuth ? _nome : null;
  }

  String? get permissao {
    return isAuth ? _permissao : null;
  }

  // Getter do userId (id do usuário), só vai retornar o userId se o user tiver autenticado
  String? get userId {
    return isAuth ? _userId : null;
  }

  // Esse método vai servir pra fazer as requisições de signup e signin
  Future<void> _authenticate(
    // String nome,
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
  Future<void> signup(String nome, String email, String password) async {
    return await _authenticate(email, password, 'signUp').then((_) async {
      await createUser(
        _token ?? '',
        _userId ?? '',
        nome,
        _email ?? '',
      );
    });
  }

  // Logar um user já existente
  Future<void> signin(String email, String password) async {
    return await _authenticate(email, password, 'signInWithPassword')
        .then((_) async {
      await getUserDetails(_token ?? '', _userId ?? '');
    });
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _nome = null;
    _permissao = null;
    _isAtivo = null;
    _expiryDate = null;
    notifyListeners();
  }

  // Método que vai criar uma collection user no realtime database com mais
  // informações (alem de email e senha) sobre o usuário criado.
  Future<void> createUser(
    String token,
    String userId,
    String nome,
    String email,
  ) async {
    String urlUsers =
        '${Constantes.DATABASE_URL}/users/$userId.json?auth=$token';
    await http.post(
      Uri.parse(urlUsers),
      body: jsonEncode(
        {
          'nome': nome,
          'email': email,
          // o default vai ser salvar como user comum, o admin vai mudar pra funcionario ou outro admin.
          'permissao': 'COMUM',
          'isAtivo': false,
        },
      ),
    );
    await getUserDetails(token, userId);
    /**
     * TODO:
     * Adicionar método que irá realizar o envio do email com código randonico de verificação de email
     * esse código vai ficar salvo no storage.
     * O código pode ser igual o do outlook (6 números)
     * O código deverá ser verificado 5 vezes no máximo. Se errar mais que isso ele vai ser enviado
     * novo código para o email pedindo pra preencher novamente.
     * Se o código for certo, vai mudar o _isAtivo de false para true na classe auth e fazer um patch
     * no firebase para deixar o user ativo.
     */
    await enviarEmailConfirmacao();
  }

  Future<void> getUserDetails(
    String token,
    String userId,
  ) async {
    String urlUsers =
        '${Constantes.DATABASE_URL}/users/$userId.json?auth=$token';
    final response = await http.get(Uri.parse(urlUsers));
    Map<String, dynamic> corpo = jsonDecode(response.body);
    corpo.forEach((key, value) {
      _idUserDetail = key;
      _nome = value['nome'];
      _email = value['email'];
      _isAtivo = value['isAtivo'];
      _permissao = value['permissao'];
    });
    notifyListeners();
  }

  // Gerar um código aleatório para confirmação do email e salvar ele localmente no dispositivo
  String _gerarCodigoConfirmacaoEmail() {
    String codigo = '';
    for (int i = 0; i < 6; i++) {
      String caractere = Random().nextInt(10).toString();
      codigo += caractere;
    }
    Storage.saveCodigo('codigoEmail', codigo);
    return codigo;
  }

  Future<void> enviarEmailConfirmacao() async {
    final String codigo = _gerarCodigoConfirmacaoEmail();
    final String msg = 'Segue o código de verificação: $codigo';
    if (_email == null) return;
    try {
      await EmailJS.send(
        'iluminaphb',
        'template_stomcze',
        {
          'user_email': _email,
          'message': msg,
          'from_name': 'IluminaPHB',
          'to_name': _nome,
          'reply_to': 'catce.2023111EPDMD0086@aluno.ifpi.edu.br',
        },
        Options(
          publicKey: Constantes.EMAILJS_PUBLIC_KEY,
          privateKey: Constantes.EMAILJS_PRIVATE_KEY,
        ),
      );
    } catch (error) {
      if (error is EmailJSResponseStatus) {
        final String msgError = 'ERROR... ${error.status}: ${error.text}';
        throw HttpException(msg: msgError, statusCode: error.status);
      }
    }
  }

  // Esse método vai ser chamado na tela de
  Future<void> ativarUser(String token, String userId, String codigo) async {
    /**
     * TODO:
     * Vamos ter que comparar o codigo recebido da tela de confirmar email com o código
     * gerado e que tá armazenado localmente
     */
    final String codigoArmazenado = await Storage.getCodigo('codigoEmail');
    if (codigo != codigoArmazenado) {
      throw EmailValidationException(msg: 'Insira o código que foi enviado');
    }
    await http.patch(
        Uri.parse(
            '${Constantes.DATABASE_URL}/users/$userId/$_idUserDetail.json?auth=$token'),
        body: jsonEncode({'isAtivo': true}));
    _isAtivo = true;
    notifyListeners();
  }
}
