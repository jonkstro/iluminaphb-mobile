import 'package:flutter/material.dart';

// Define a classe AdaptativeTextfield, que é um componente de campo de texto adaptativo.
class AdaptativeTextfield extends StatelessWidget {
  // Declaração de atributos obrigatórios para a construção do componente.
  final String label; // Rótulo do campo de texto.
  final TextInputType keyboardType; // Tipo de teclado a ser exibido.
  final TextEditingController
      controller; // Controlador para manipulação do conteúdo do campo.
  final bool
      isObscure; // Indica se o texto deve ser obscurecido (geralmente usado para senhas).
  final Widget? iconButton; // Ícone opcional a ser exibido no campo.

  // Construtor da classe AdaptativeTextfield, que recebe os parâmetros obrigatórios e opcionais.
  const AdaptativeTextfield({
    super.key, // Chama o construtor da classe pai (superclasse).
    required this.label, // Parâmetro obrigatório: rótulo do campo.
    this.keyboardType = TextInputType
        .text, // Parâmetro opcional: tipo de teclado (padrão é TextInputType.text).
    required this.controller, // Parâmetro obrigatório: controlador do campo.
    this.isObscure =
        false, // Parâmetro opcional: indicação de texto obscurecido (padrão é false).
    this.iconButton, // Parâmetro opcional: ícone a ser exibido no campo.
  });

  // Implementação do método de construção do componente.
  @override
  Widget build(BuildContext context) {
    // Retorna um TextField, um widget de campo de texto padrão do Flutter.
    return TextField(
      controller:
          controller, // Define o controlador fornecido como o controlador do TextField.
      keyboardType:
          keyboardType, // Define o tipo de teclado fornecido para o TextField.
      obscureText:
          isObscure, // Define se o texto deve ser obscurecido com base no parâmetro fornecido.
      style: TextStyle(
        color: Theme.of(context)
            .textTheme
            .bodySmall
            ?.color, // Define a cor do texto com base no tema atual.
      ),
      decoration: InputDecoration(
        label: Text(
          label, // Define o rótulo do campo de texto com base no parâmetro fornecido.
        ),
        suffixIcon:
            iconButton, // Define o ícone a ser exibido à direita do campo com base no parâmetro fornecido.
      ),
    );
  }
}
