// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iluminaphb/models/auth.dart';
import 'package:iluminaphb/pages/home_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';

import '../components/adaptative_alert_dialog.dart';

class EmailCodePage extends StatefulWidget {
  final Auth auth;
  const EmailCodePage({super.key, required this.auth});

  @override
  State<EmailCodePage> createState() => _EmailCodePageState();
}

class _EmailCodePageState extends State<EmailCodePage> {
  bool _isLoading = false;

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

  Future<void> _reenviarEmail() async {
    setState(() => _isLoading = true);
    try {
      await widget.auth.enviarEmailConfirmacao();
      // Navegar para a tela de preenchimento do código enviado pro email
      await showDialog(
        context: context,
        builder: (ctx) => AdaptativeAlertDialog(
          msg: 'Email enviado!',
          corpo:
              'Reenviamos o código de validação para o email ${widget.auth.email}. \nCaso não encontre o email na caixa de entrada, verifique a caixa de SPAM.}',
          isError: false,
        ),
      );
      // Ir pra tela de Preencher o código após fechar o dialog
      // Navigator.of(context).pushReplacementNamed(
      //   AppRoutes.HOME,
      //   arguments: const EmailValidationPage(),
      // );
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quase lá',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              Text(
                'Identificamos que você não verificou ainda o seu endereço de e-mail',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 200,
                width: 450,
                child: Image(image: AssetImage('assets/images/email-dog.png')),
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: Icon(
                        Icons.email,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      label: Text(
                        'Reenviar código para email',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () async {
                        _reenviarEmail();
                      },
                    ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).inputDecorationTheme.fillColor,
                ),
                label: Text(
                  'Voltar para tela inicial',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  widget.auth.logout();
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.HOME,
                    arguments: HomePage(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
