import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

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
  String? _refreshToken;
  String? _email;
  String? _userId;
  String? _nome;
  String? _permissao;
  bool? _isAtivo;
  DateTime? _expiryDate;
  String? _idUserDetail;

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
      _refreshToken = body['refreshToken'];
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
  Future<void> signin(
      String email, String password, bool continuarLogado) async {
    return await _authenticate(email, password, 'signInWithPassword')
        .then((_) async {
      await getUserDetails(_token ?? '', _userId ?? '');
      // SALVAR OS DADOS DO LOGIN EM MEMÓRIA - INICIO
      // Quando fazer login, se tiver marcado o checkbox, vai guardar os dados retornados em memória
      if (continuarLogado) {
        await Storage.saveMap('userData', {
          'token': _token,
          'refreshToken': _refreshToken,
          'email': _email,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
          'nome': _nome,
          'isAtivo': _isAtivo,
          'permissao': _permissao,
          'idUserDetail': _idUserDetail
        });
      }
      // SALVAR OS DADOS DO LOGIN EM MEMÓRIA - FINAL
    });
  }

  Future<void> _updateAccountData(String email, String password) async {
    return await _authenticate(_email ?? '', password, 'update')
        .then((_) async {
      await getUserDetails(_token ?? '', _userId ?? '');
    });
  }

  // SALVAR OS DADOS DO LOGIN EM MEMÓRIA - INICIO
  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Storage.getMap('userData');
    // Se userData for vazio (não tiver no storage), faz nada
    if (userData.isEmpty) return;

    // Se a data de expiração for antes de agora [no passado], renova o token
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      // vai retornar 2 tokens novos que vou armazenar local pra buscar dnv abaixo
      await _renovarToken(
        userData['email'],
        userData['nome'],
        userData['userId'],
        userData['isAtivo'],
        userData['permissao'],
        userData['idUserDetail'],
        userData['refreshToken'],
      );
    }
    // Se chegou até aqui, vai ser atualizado os dados com o que tá no storage
    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    _nome = userData['nome'];
    _isAtivo = userData['isAtivo'];
    _permissao = userData['permissao'];
    _idUserDetail = userData['idUserDetail'];
    _refreshToken = userData['refreshToken'];

    notifyListeners();
  }

  Future<void> _renovarToken(
    String emailRecebido,
    String nomeRecebido,
    String userIdRecebido,
    bool isAtivoRecebido,
    String permissaoRecebido,
    String idUserDetailRecebido,
    String refreshTokenRecebido,
  ) async {
    final response = await http.post(
      Uri.parse(Constantes.AUTH_REFRESH_URL),
      body: jsonEncode(
        {
          'grant_type': 'refresh_token',
          'refresh_token': refreshTokenRecebido,
        },
      ),
    );
    final corpo = jsonDecode(response.body);
    if (corpo['error'] != null) {
      // Se retornar erro no response da requisição:
      throw AuthException(key: corpo['error']['message']);
    } else {
      await Storage.saveMap('userData', {
        'token': corpo['id_token'],
        'refreshToken': corpo['refresh_token'],
        'email': emailRecebido,
        'userId': userIdRecebido,
        'nome': nomeRecebido,
        'isAtivo': isAtivoRecebido,
        'permissao': permissaoRecebido,
        'idUserDetail': idUserDetailRecebido,
        'expiryDate': DateTime.now()
            .add(Duration(seconds: int.parse(corpo['expires_in'])))
            .toIso8601String(),
      });
    }
  }
  // SALVAR OS DADOS DO LOGIN EM MEMÓRIA - FINAL

  Future<void> logout() async {
    _token = null;
    _email = null;
    _userId = null;
    _nome = null;
    _permissao = null;
    _isAtivo = null;
    _expiryDate = null;

    // SALVAR OS DADOS DO LOGIN EM MEMÓRIA - INICIO
    final userData = await Storage.getMap('userData');
    // Se userData for vazio (não tiver no storage), faz nada
    if (userData.isNotEmpty) {
      // Remover os dados do usuário quando fizer logout
      Storage.remove('userData').then((_) {
        // Só vai atualizar os interessados quando tiver certeza que apagou no storage
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
    // SALVAR OS DADOS DO LOGIN EM MEMÓRIA - FINAL
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
      DateTime agora = DateTime.now();
      String formato = 'dd/MM/yyyy HH:mm:ss';
      String dataHoraFormatada = DateFormat(formato).format(agora);
      await EmailJS.send(
        'iluminaphb',
        'template_stomcze',
        {
          'user_email': _email,
          'message': msg,
          'from_name': 'IluminaPHB',
          'to_name': _nome,
          'reply_to': 'catce.2023111EPDMD0086@aluno.ifpi.edu.br',
          'data_hora': dataHoraFormatada,
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

  Future<void> enviarEmailMudancaSenha(String email) async {
    final String codigo = _gerarCodigoConfirmacaoEmail();
    final String msg = 'Segue o código de verificação: $codigo';
    try {
      DateTime agora = DateTime.now();
      String formato = 'dd/MM/yyyy HH:mm:ss';
      String dataHoraFormatada = DateFormat(formato).format(agora);
      await EmailJS.send(
        'iluminaphb',
        'template_stomcze',
        {
          'user_email': email,
          'message': msg,
          'from_name': 'IluminaPHB',
          'to_name': email,
          'reply_to': 'catce.2023111EPDMD0086@aluno.ifpi.edu.br',
          'data_hora': dataHoraFormatada,
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
    final isCodigoValido = await validarCodigo(codigo);
    if (!isCodigoValido) {
      throw EmailValidationException(
          msg:
              'O código inserido não confere com o código que foi enviado para o seu email.');
    }
    await http.patch(
        Uri.parse(
            '${Constantes.DATABASE_URL}/users/$userId/$_idUserDetail.json?auth=$token'),
        body: jsonEncode({'isAtivo': true}));
    _isAtivo = true;
    notifyListeners();
  }

  // Esse método vai ser chamado na tela de trocar senha
  Future<void> esqueceuSuaSenha(
    String senha,
    String codigo,
  ) async {
    final isCodigoValido = await validarCodigo(codigo);
    if (!isCodigoValido) {
      throw EmailValidationException(msg: 'Insira o código que foi enviado');
    }
    await _updateAccountData('', senha);
    // Após mudar a senha, vamos fazer um logout pra zerar todos dados.
    logout();
  }

  Future<bool> validarCodigo(String codigo) async {
    final String codigoArmazenado = await Storage.getCodigo('codigoEmail');
    if (codigo != codigoArmazenado) {
      return false;
    } else {
      return true;
    }
  }
}
