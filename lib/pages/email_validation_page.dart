// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iluminaphb/components/email_verification_form.dart';
import 'package:iluminaphb/models/auth.dart';
import 'package:iluminaphb/pages/home_page.dart';

import '../components/adaptative_alert_dialog.dart';
import '../utils/app_routes.dart';

class EmailValidationPage extends StatefulWidget {
  final Auth auth;
  const EmailValidationPage({super.key, required this.auth});

  @override
  State<EmailValidationPage> createState() => _EmailValidationPageState();
}

class _EmailValidationPageState extends State<EmailValidationPage> {
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
              'Reenviamos o código de validação para o email ${widget.auth.email}. \nCaso não encontre o email na caixa de entrada, verifique a caixa de SPAM.',
          isError: false,
        ),
      );
      // Ir pra tela de Preencher o código após fechar o dialog
      Navigator.of(context).pushNamed(AppRoutes.HOME,
          arguments: EmailValidationPage(auth: widget.auth));
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Auth auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        actionsIconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          'Código de Verificação',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ), // Ícone de impressão (substitua pelo desejado)
          onPressed: () {
            // Lógica para ação de impressão ou qualquer outra ação desejada
            widget.auth.logout();
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.HOME, arguments: HomePage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quase lá',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // const SizedBox(
            //   height: 200,
            //   width: 450,
            //   child: Image(image: AssetImage('assets/images/email-dog.png')),
            // ),
            Text(
              'Preencha o código que foi enviado para o email ${widget.auth.email}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'Se não conseguir encontrar o email na sua caixa de entrada, verifique na sua caixa de SPAM',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            EmailVerificationForm(auth: widget.auth),

            const SizedBox(height: 50),
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
                'Voltar para tela de login',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              onPressed: () async {
                widget.auth.logout();
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.HOME,
                  arguments: HomePage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
