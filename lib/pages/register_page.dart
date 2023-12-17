import 'package:flutter/material.dart';
import 'package:iluminaphb/pages/login_page.dart';

import '../components/adaptative_textfield.dart';
import '../utils/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Variável para controlar a visibilidade da senha
  bool _esconderSenha = true;
  bool _esconderConfirmarSenha = true;

  // Função para alternar a visibilidade da senha
  void _mudarVisibilidadeSenha() {
    setState(() {
      _esconderSenha = !_esconderSenha;
    });
  }

  // Widget para criar o ícone de visibilidade da senha
  Widget _createIconeSenha(VoidCallback onPressed, bool variavel) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        variavel ? Icons.visibility : Icons.visibility_off,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }

  // Widget para criar um botão de texto
  Widget _createTextButton(
      {required String texto, required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        texto,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  // Controlador para o campo de nome
  final _nomeController = TextEditingController();
  // Controlador para o campo de email
  final _emailController = TextEditingController();
  // Controlador para o campo de senha
  final _passwordController = TextEditingController();
  // Controlador para o campo de confirmar senha
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Criar uma nova conta',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              FittedBox(
                child: Text(
                  'Já tem uma conta? ',
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
                      'Faça Login',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    _createTextButton(
                      texto: 'Criar conta',
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.HOME,
                          arguments: const LoginPage(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 600,
                child: AdaptativeTextfield(
                  label: 'Preencha o seu email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 600,
                child: AdaptativeTextfield(
                  label: 'Preencha a sua senha',
                  controller: _passwordController,
                  isObscure: _esconderSenha,
                  iconButton: _createIconeSenha(
                    _mudarVisibilidadeSenha,
                    _esconderSenha,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Botão para "Esqueceu a senha"
              _createTextButton(
                texto: 'Esqueceu a sua senha ?',
                onPressed: () {},
              ),
              const SizedBox(height: 25),
              // Botão de login
              ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(5),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'QuickSand',
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
