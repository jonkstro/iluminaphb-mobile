// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iluminaphb/models/auth.dart';
import 'package:iluminaphb/pages/password_reset_page.dart';
import 'package:provider/provider.dart';

import '../components/adaptative_alert_dialog.dart';
import '../utils/app_routes.dart';

class PasswordForgetPage extends StatefulWidget {
  const PasswordForgetPage({super.key});

  @override
  State<PasswordForgetPage> createState() => _PasswordForgetPageState();
}

class _PasswordForgetPageState extends State<PasswordForgetPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  // Chave que irá identificar o formulário no submit
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _enviarEmail(String email) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false)
          .enviarEmailMudancaSenha(email);
      // Navegar para a tela de preenchimento do código enviado pro email
      await showDialog(
        context: context,
        builder: (ctx) => AdaptativeAlertDialog(
          msg: 'Email enviado!',
          corpo:
              'Reenviamos o código de validação para o email $email. \nCaso não encontre o email na caixa de entrada, verifique a caixa de SPAM.',
          isError: false,
        ),
      );
      // Ir pra tela de Preencher o código após fechar o dialog
      Navigator.of(context)
          .pushNamed(AppRoutes.HOME, arguments: const PasswordResetPage());
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    setState(() => _isLoading = false);
  }

  Future<void> _submitForm() async {
    // Validação dos campos do formulario: Se tiver o que validar ele valida,
    //se não tiver nada pra validar manda false pois deu algum erro
    final isValid = _formKey.currentState?.validate() ?? false;
    // Se não for válido (isValid = false) ele vai fazer nada, vai acabar aqui
    if (!isValid) {
      return;
    }
    // Vai salvar cada um dos campos do form chamando o onSaved de cada um
    _formKey.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // actionsIconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Preencha o seu email',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Enviaremos um código de validação para o email que será preenchido',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: 600,
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Preencha o seu email',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final email = value ?? '';
                  // Remover espaços em branco no início e no final da string e ver se tem @
                  if (email.trim().isEmpty ||
                      !email.contains('@') ||
                      !(email.contains('.com') || email.contains('.edu.br'))) {
                    return 'Informe um email válido';
                  }
                  return null;
                },
              ),
            ),
          ),
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
                    _submitForm();
                  },
                ),
        ],
      ),
    );
  }
}
