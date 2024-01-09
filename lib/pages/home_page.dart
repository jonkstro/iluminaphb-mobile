// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:iluminaphb/pages/select_service_page.dart';
import 'package:iluminaphb/pages/unknown_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Vai receber se tá logado, se tiver logado vai pra plataforma,
    // senão vai pra tela de login
    Auth auth = Provider.of<Auth>(context);
    final String? tipoUser = auth.permissao;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: auth.isAuth
          ? auth.isAtivo
              ? SelectServicePage(tipoUser: tipoUser ?? 'COMUM')
              // TODO: Criar página de confirmação do email
              : const UnknownPage()
          : const AuthPage(),
    );
  }
}
