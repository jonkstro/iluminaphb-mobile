import 'package:flutter/material.dart';
import 'package:iluminaphb/enums/tipo_user_enum.dart';
import 'package:iluminaphb/pages/select_service_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';
import 'unknown_page.dart';

class HomePage extends StatelessWidget {
  TipoUserEnum _tipoUser = TipoUserEnum.COMUM;

  @override
  Widget build(BuildContext context) {
    // Vai receber se tá logado, se tiver logado vai pra plataforma,
    // senão vai pra tela de login
    Auth auth = Provider.of<Auth>(context);

    return Container(
      constraints: const BoxConstraints.expand(),
      // child: auth.isAuth
      //     ? SelectServicePage(tipoUser: _tipoUser)
      //     : const AuthPage(),
      child: SelectServicePage(tipoUser: _tipoUser),
      // child: const AuthPage(),
    );
  }
}
