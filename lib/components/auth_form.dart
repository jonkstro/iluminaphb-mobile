// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iluminaphb/components/adaptative_alert_dialog.dart';
import 'package:iluminaphb/exceptions/auth_exception.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

// Enum que vai alternar entre as telas de login e register
enum AuthMode { SIGNUP, LOGIN }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _confpasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  // Chave que irá identificar o formulário no submit
  final _formKey = GlobalKey<FormState>();
  // Iniciando na tela de login
  AuthMode _authMode = AuthMode.LOGIN;
  bool _isLoading = false;
  // Variável para controlar a visibilidade da senha
  bool _esconderSenha = true;
  bool _esconderConfirmarSenha = true;

  // Dados do formulário, irá iniciar vazio
  Map<String, String> _authData = {
    'nome': '',
    'email': '',
    'password': '',
  };

  // Vai dizer se tá login ou tá signup
  bool _isLogin() => _authMode == AuthMode.LOGIN;
  bool _isSignUp() => _authMode == AuthMode.SIGNUP;

  @override
  void dispose() {
    super.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confpasswordController.dispose();
  }

  /// ---------- MUDAR O ESTADO DO FORMULÁRIO (INÍCIO) ----------

  void _switchAuthMode() {
    setState(() {
      _nomeController.text = '';
      _emailController.text = '';
      _confpasswordController.text = '';
      _passwordController.text = '';
      _esconderSenha = true;
      _esconderConfirmarSenha = true;
      if (_isLogin()) {
        _authMode = AuthMode.SIGNUP;
      } else {
        _authMode = AuthMode.LOGIN;
      }
    });
  }

  // Função para alternar a visibilidade da senha
  void _mudarVisibilidadeSenha() {
    setState(() {
      _esconderSenha = !_esconderSenha;
    });
  }

  void _mudarVisibilidadeConfirmarSenha() {
    setState(() {
      _esconderConfirmarSenha = !_esconderConfirmarSenha;
    });
  }

  /// ---------- MUDAR O ESTADO DO FORMULÁRIO (FIM) ----------

  // Método que vai retornar o Dialog com a mensagem de erro que retornar do firebase
  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AdaptativeAlertDialog(
        msg: 'Ocorreu um erro',
        corpo: msg,
        isError: true,
      ),
    );
  }

  // Método que vai realizar a validação do form pra mandar pro firebase
  Future<void> _submitForm() async {
    // Validação dos campos do formulario: Se tiver o que validar ele valida,
    //se não tiver nada pra validar manda false pois deu algum erro
    final isValid = _formKey.currentState?.validate() ?? false;
    // Se não for válido (isValid = false) ele vai fazer nada, vai acabar aqui
    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    // Vai salvar cada um dos campos do form chamando o onSaved de cada um
    _formKey.currentState?.save();
    // listen = false pois tá fora do build, senão quebra a aplicação
    Auth auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_isLogin()) {
        // Login
        // Os 2 valores já tão setados como '' no início do programa por isso o '!'
        await auth.signin(_authData['email']!, _authData['password']!);
      } else {
        // Registrar
        // Os 2 valores já tão setados como '' no início do programa por isso o '!'
        await auth.signup(
          _authData['nome']!,
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _isLogin() ? 'Login' : 'Criar uma nova conta',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        FittedBox(
          child: Text(
            _isLogin() ? 'Faça login para acessar a plataforma' : ' ',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 5),
        // Botão para navegar para a página de registro ao clicar
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin() ? 'Não tem uma conta ainda?' : 'Já tem uma conta?',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              // const SizedBox(width: 15),
              TextButton(
                onPressed: () {
                  _switchAuthMode();
                },
                child: Text(
                  _isLogin() ? 'Registre-se' : 'Faça login',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              if (_isSignUp())
                SizedBox(
                  width: 600,
                  child: TextFormField(
                    controller: _nomeController,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    // Vai adicionar o authData o valor do campo, se tiver vazio vai botar ''
                    onSaved: (nome) => _authData['nome'] = nome ?? '',
                    validator: (value) {
                      final nome = value ?? '';
                      // Remover espaços em branco no início e no final da string e ver se tem @
                      if (nome.trim().isEmpty) {
                        return 'Informe um nome válido';
                      }
                      return null;
                    },
                  ),
                ),
              if (_isSignUp()) const SizedBox(height: 15),
              SizedBox(
                width: 600,
                child: TextFormField(
                  controller: _emailController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Preencha o seu email',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  // Vai adicionar o authData o valor do campo, se tiver vazio vai botar ''
                  onSaved: (email) => _authData['email'] = email ?? '',

                  validator: _isLogin()
                      ? null
                      : (value) {
                          final email = value ?? '';
                          // Remover espaços em branco no início e no final da string e ver se tem @
                          if (email.trim().isEmpty ||
                              !email.contains('@') ||
                              !email.contains('.com')) {
                            return 'Informe um email válido';
                          }
                          return null;
                        },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 600,
                child: TextFormField(
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _esconderSenha
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      onPressed: () => _mudarVisibilidadeSenha(),
                    ),
                  ),
                  textInputAction:
                      _isLogin() ? TextInputAction.done : TextInputAction.next,
                  keyboardType: TextInputType.text,
                  obscureText: _esconderSenha,
                  // Vai adicionar o authData o valor do campo, se tiver vazio vai botar ''
                  onSaved: (password) => _authData['password'] = password ?? '',
                  validator: _isLogin()
                      ? null
                      : (value) {
                          final password = value ?? '';
                          List<String> erros = [];
                          // Verificar se a senha é vazia ou tem menos de 5 caracteres
                          if (password.isEmpty || password.length < 5) {
                            erros.add('Preencha ao menos 5 caracteres');
                          }

                          // Verificar se a senha contém pelo menos uma letra maiúscula
                          if (!password.contains(RegExp(r'[A-Z]'))) {
                            erros.add('Preencha ao menos uma letra maiúscula');
                          }

                          // Verificar se a senha contém pelo menos uma letra minúscula
                          if (!password.contains(RegExp(r'[a-z]'))) {
                            erros.add('Preencha ao menos uma letra minúscula');
                          }

                          // Verificar se a senha contém pelo menos um número
                          if (!password.contains(RegExp(r'[0-9]'))) {
                            erros.add('Preencha ao menos um número');
                          }

                          // Verificar se a senha contém pelo menos um caractere especial
                          if (!password
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            erros
                                .add('Preencha ao menos um caractere especial');
                          }

                          // Se houver erros, retorna a mensagem concatenada; caso contrário, retorna null
                          return erros.isNotEmpty ? erros.join('\n') : null;
                        },
                ),
              ),
              if (_isSignUp()) const SizedBox(height: 15),
              if (_isSignUp())
                SizedBox(
                  width: 600,
                  child: TextFormField(
                    controller: _confpasswordController,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _esconderConfirmarSenha
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        onPressed: () => _mudarVisibilidadeConfirmarSenha(),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    obscureText: _esconderConfirmarSenha,
                    // Só chama o validador se for tela de Signup
                    validator: _isSignUp()
                        ? (value) {
                            final password = value ?? '';
                            if (password != _passwordController.text) {
                              return 'Senhas informadas não conferem';
                            }
                            return null;
                          }
                        : null,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        // Botão para "Esqueceu a senha". TODO: Criar pagina de esqueceu senha
        if (_isLogin())
          TextButton(
            onPressed: () {},
            child: Text(
              'Esqueceu a sua senha ?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        // Botão de login, se apertar ele chama o submit e muda pra progressive circle
        if (_isLoading)
          const CircularProgressIndicator()
        else
          Container(
            margin: const EdgeInsets.only(top: 25),
            constraints: const BoxConstraints(minWidth: 240, minHeight: 60),
            child: ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: const Color.fromRGBO(113, 92, 248, 1),
              ),
              child: Text(
                _isLogin() ? 'LOGIN' : 'REGISTRAR',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
