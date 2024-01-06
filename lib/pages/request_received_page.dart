import 'package:flutter/material.dart';
import 'package:iluminaphb/components/adaptative_button.dart';
import 'package:iluminaphb/pages/home_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';

class RequestReceivedPage extends StatelessWidget {
  const RequestReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tamanho = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: tamanho.width <= 800
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                FittedBox(
                  child: Center(
                    child: Text(
                      'Sua solicitação foi recebida!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'Fique atento à sua caixa de entrada!\n\nEm breve enviaremos atualizações sobre o andamento da sua solicitação.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: tamanho.width <= 800 ? -30 : -360,
          child: Image(
            image: const AssetImage('assets/images/eletricista.png'),
            width: tamanho.width <= 600 ? tamanho.width : 800,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: SizedBox(
            height: 100,
            width: tamanho.width <= 600 ? tamanho.width * 0.75 : 800,
            child: AdaptativeButton(
              texto: 'Voltar para a tela inicial',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.HOME,
                  arguments: HomePage(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
