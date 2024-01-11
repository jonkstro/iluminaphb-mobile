// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iluminaphb/exceptions/email_validation_exception.dart';
import 'package:iluminaphb/models/auth.dart';
import 'package:iluminaphb/pages/home_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';

import 'adaptative_alert_dialog.dart';
import 'adaptative_button.dart';

class EmailVerificationForm extends StatefulWidget {
  final Auth auth;
  const EmailVerificationForm({super.key, required this.auth});

  @override
  _EmailVerificationFormState createState() => _EmailVerificationFormState();
}

class _EmailVerificationFormState extends State<EmailVerificationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    // Validação dos campos do formulario: Se tiver o que validar ele valida,
    //se não tiver nada pra validar (chave for vazia) manda false pois deu algum erro
    final isValid = _formKey.currentState?.validate() ?? false;
    // Se não for válido (isValid = false) ele vai fazer nada, vai acabar aqui
    if (!isValid) {
      return;
    }
    Auth auth = widget.auth;
    setState(() => _isLoading = true);
    try {
      await auth
          .ativarUser(
        auth.token ?? '',
        auth.userId ?? '',
        _codeController.text,
      )
          // Depois que der certo, voltar pra tela inicial
          .then(
        (value) async {
          await showDialog(
            context: context,
            builder: (ctx) => const AdaptativeAlertDialog(
              msg: 'Email validado',
              corpo:
                  'Seu email foi validado com sucesso! \nJá pode realizar o login na plataforma',
              isError: false,
            ),
          );
          auth.logout();
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.HOME,
            arguments: HomePage(),
          );
        },
      );
    } on EmailValidationException catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AdaptativeAlertDialog(
          msg: 'Código incorreto',
          corpo: error.toString(),
          isError: true,
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AdaptativeAlertDialog(
          msg: 'Ocorreu um erro inesperado',
          corpo: 'Erro: ${error.toString()}',
          isError: true,
        ),
      );
    } finally {
      setState(() {
        _codeController.text = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: const InputDecoration(hintText: '000000'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                // Vai adicionar o _formData o valor do campo, se tiver vazio vai botar ''
                controller: _codeController,
                validator: (value) {
                  final code = value ?? '';
                  if (code.trim().length < 6) {
                    return 'Informe um código válido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 120,
                child: _isLoading
                    ? Container(
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : AdaptativeButton(
                        texto: 'Validar email',
                        onPressed: () => _submitForm(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
