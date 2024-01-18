// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:iluminaphb/pages/select_profile_page.dart';
import 'package:iluminaphb/pages/select_service_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';
import 'email_validation_page.dart';

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

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return Container(
            constraints: const BoxConstraints.expand(),
            child: auth.isAuth
                ? FutureBuilder(
                    // Esperar 3 segundos pra poder pegar o isAtivo sem quebrar nada
                    future: Future.delayed(const Duration(seconds: 3)),
                    // future: ,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.error != null) {
                        return const Center(
                          child: Text('Ocorreu um erro!'),
                        );
                      } else {
                        if (isAtivo!) {
                          if (tipoUser == 'COMUM') {
                            // Se for user comum, não vai poder escolher a tela
                            return const SelectServicePage(
                              tipoUser: 'COMUM',
                            );
                          } else {
                            // Se for funcionário ou admin, vai pra tela pra escolher telas
                            return const SelectProfilePage();
                          }
                        } else {
                          // Se não tiver ativo, vai pra tela de validar o email
                          return EmailValidationPage(auth: auth);
                        }
                      }
                    },
                  )
                // Se não tiver autenticado, volta pra tela de login
                : const AuthPage(),
          );
        }
      },
    );
  }
}
