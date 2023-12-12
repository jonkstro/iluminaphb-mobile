// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _esconderSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Evita que os widgets subam com o teclado
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontFamily:
                    Theme.of(context).textTheme.headlineMedium?.fontFamily,
                fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                fontWeight:
                    Theme.of(context).textTheme.headlineMedium?.fontWeight,
                color: Theme.of(context).textTheme.headlineMedium?.color,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Faça login para acessar a plataforma',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // FittedBox vai reduzir os espaços pra não dar pau no app
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem uma conta ainda?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodySmall?.fontFamily,
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                      fontWeight:
                          Theme.of(context).textTheme.bodySmall?.fontWeight,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Registre-se',
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodySmall?.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Preencha seu email"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                keyboardType: TextInputType.text,
                obscureText: _esconderSenha,
                decoration: InputDecoration(
                  label: const Text(
                    "Preencha sua senha",
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _esconderSenha = !_esconderSenha;
                      });
                    },
                    icon: Icon(
                      _esconderSenha ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'QuickSand',
                      fontWeight: FontWeight.normal,
                      fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
