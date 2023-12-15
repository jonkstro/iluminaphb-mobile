import 'package:flutter/material.dart';
import 'package:iluminaphb/screens/login_screen.dart';
import 'package:iluminaphb/utils/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Variavel que vai alterar o estado quando for clicada
  bool _esconderSenha = true;
  bool _esconderConfirmarSenha = true;

  // Função que vai ser executada quando clicar no botão de mudar a senha
  void _mudarVisibilidadeSenha() {
    setState(() {
      _esconderSenha = !_esconderSenha;
    });
  }

  // Função que vai ser executada quando clicar no botão de mudar a senha
  void _mudarVisibilidadeConfirmarSenha() {
    setState(() {
      _esconderConfirmarSenha = !_esconderConfirmarSenha;
    });
  }

  // Reaproveitaremos o icone, por isso estamos criando por função
  Widget _createIconeSenha(VoidCallback onPressed, bool variavel) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        variavel ? Icons.visibility : Icons.visibility_off,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }

  // Reaproveitaremos o mesmo textfield, por isso estamos criando com função e recebendo params.
  Widget _createTextField({
    required String texto,
    required TextInputType tipoTeclado,
    required bool esconderSenha,
    Widget? iconButton,
  }) {
    return TextField(
      style: TextStyle(
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      keyboardType: tipoTeclado,
      obscureText: esconderSenha,
      decoration: InputDecoration(
        label: Text(
          texto,
        ),
        suffixIcon: iconButton,
      ),
    );
  }

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
                'Criar conta',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              FittedBox(
                child: Text(
                  'Crie sua conta para poder acessar a plataforma',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 5),
              // FittedBox vai reduzir os espaços pra não dar pau no app
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    _createTextButton(
                      texto: 'Fazer login',
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.HOME,
                          arguments: const LoginScreen(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 600,
                child: _createTextField(
                    texto: "Preencha o seu nome",
                    tipoTeclado: TextInputType.text,
                    esconderSenha: false,
                    iconButton: null),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 600,
                child: _createTextField(
                    texto: "Preencha o seu email",
                    tipoTeclado: TextInputType.emailAddress,
                    esconderSenha: false,
                    iconButton: null),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 600,
                child: _createTextField(
                  texto: "Preencha a sua senha",
                  tipoTeclado: TextInputType.text,
                  esconderSenha: _esconderSenha,
                  iconButton: _createIconeSenha(
                    _mudarVisibilidadeSenha,
                    _esconderSenha,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 600,
                child: _createTextField(
                  texto: "Repita a sua senha",
                  tipoTeclado: TextInputType.text,
                  esconderSenha: _esconderConfirmarSenha,
                  iconButton: _createIconeSenha(
                    _mudarVisibilidadeConfirmarSenha,
                    _esconderConfirmarSenha,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _createTextButton(
                  texto: 'Esqueceu a sua senha ?', onPressed: () {}),
              const SizedBox(height: 25),
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
