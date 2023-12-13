import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variavel que vai alterar o estado quando for clicada
  bool _esconderSenha = true;

  // Função que vai ser executada quando clicar no botão de mudar a senha
  void _mudarVisibilidadeSenha() {
    setState(() {
      _esconderSenha = !_esconderSenha;
    });
  }

  // Reaproveitaremos o icone, por isso estamos criando por função
  Widget _createIconeSenha() {
    return IconButton(
      onPressed: () {
        _mudarVisibilidadeSenha();
      },
      icon: Icon(
        _esconderSenha ? Icons.visibility : Icons.visibility_off,
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
      {required String texto, required Function onPressed}) {
    return TextButton(
      onPressed: onPressed(),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 15),
            Text(
              'Faça login para acessar a plataforma',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 5),
            // FittedBox vai reduzir os espaços pra não dar pau no app
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem uma conta ainda?',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  // Vai navegar para a tela de registrar usuario
                  _createTextButton(texto: 'Registre-se', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: _createTextField(
                  texto: "Preencha o seu email",
                  tipoTeclado: TextInputType.emailAddress,
                  esconderSenha: false,
                  iconButton: null),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: _createTextField(
                texto: "Preencha a sua senha",
                tipoTeclado: TextInputType.text,
                esconderSenha: _esconderSenha,
                iconButton: _createIconeSenha(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              // Vai navegar para a tela de esqueceu senha
              child: _createTextButton(
                  texto: 'Esqueceu a sua senha ?', onPressed: () {}),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              child: ElevatedButton(
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
            ),
          ],
        ),
    );
  }
}
