// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:iluminaphb/pages/select_service_page.dart';
import 'package:iluminaphb/pages/unknown_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Vai receber se tá logado, se tiver logado vai pra plataforma,
    // senão vai pra tela de login
    Auth auth = Provider.of<Auth>(context);
    final String? tipoUser = auth.permissao;
    bool? isAtivo = auth.isAtivo;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: auth.isAuth
          ? FutureBuilder(
              // Esperar 3 segundos pra poder pegar o isAtivo sem quebrar nada
              future: Future.delayed(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (isAtivo!) {
                    return SelectServicePage(tipoUser: tipoUser ?? 'COMUM');
                  } else {
                    return const UnknownPage();
                  }
                }
              },
            )
          : const AuthPage(),
    );
  }
}
