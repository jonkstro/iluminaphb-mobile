// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

// Enum que vai alternar entre as telas de login e register
enum AuthMode { SIGNUP, LOGIN }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // Iniciando na tela de login
  AuthMode _authMode = AuthMode.LOGIN;
  bool _isLoading = false;
  // Variável para controlar a visibilidade da senha
  bool _esconderSenha = true;
  bool _esconderConfirmarSenha = true;

  // Vai dizer se tá login ou tá signup
  bool _isLogin() => _authMode == AuthMode.LOGIN;
  bool _isSignUp() => _authMode == AuthMode.SIGNUP;

  void _switchAuthMode() {
    setState(() {
      // _emailController.text = '';
      // _confpasswordController.text = '';
      // _passwordController.text = '';
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

  void _submitForm() {
    setState(() => _isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _isLogin() ? 'Login' : 'Criar uma nova conta',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 15),
        FittedBox(
          child: Text(
            _isLogin() ? 'Faça login para acessar a plataforma' : '',
            style: Theme.of(context).textTheme.bodySmall,
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
              const SizedBox(width: 15),
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
          child: Column(
            children: <Widget>[
              if (_isSignUp())
                SizedBox(
                  width: 600,
                  child: TextFormField(
                    initialValue: '',
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              if (_isSignUp()) const SizedBox(height: 15),
              SizedBox(
                width: 600,
                child: TextFormField(
                  initialValue: '',
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 600,
                child: TextFormField(
                  initialValue: '',
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
                ),
              ),
              if (_isSignUp()) const SizedBox(height: 15),
              if (_isSignUp())
                SizedBox(
                  width: 600,
                  child: TextFormField(
                    initialValue: '',
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
                    obscureText: _esconderSenha,
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
        if (_isLogin()) const SizedBox(height: 25),
        // Botão de login, se apertar ele chama o submit e muda pra progressive circle
        if (_isLoading)
          const CircularProgressIndicator()
        else
          Container(
            constraints: const BoxConstraints(minWidth: 240, minHeight: 60),
            child: ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(5),
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
