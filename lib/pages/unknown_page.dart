import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página não encontrada'),
        centerTitle: true,
      ),
      body: Center(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagem hospedada na Web
              const SizedBox(
                height: 300,
                width: 450,
                child: Image(image: AssetImage('assets/images/404-cat.png')),
              ),
              Text(
                'Essa página não existe ainda 😿',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
