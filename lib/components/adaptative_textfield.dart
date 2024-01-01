import 'package:flutter/material.dart';

// Define a classe AdaptativeTextfield, que é um componente de campo de texto adaptativo.
class AdaptativeTextfield extends StatelessWidget {
  // Declaração de atributos obrigatórios para a construção do componente.
  final String label; // Rótulo do campo de texto.
  final TextInputType keyboardType; // Tipo de teclado a ser exibido.
  // Controlador para manipulação do conteúdo do campo
  final TextEditingController controller;
  // Indica se o texto deve ser obscurecido (geralmente usado para senhas).
  final bool isObscure;
  final Widget? iconButton; // Ícone opcional a ser exibido no campo.
  // Ao submitar, vai focar nesse próximo textfield
  final FocusNode thisFocus;
  final FocusNode? nextFocus;

  // Construtor da classe AdaptativeTextfield, que recebe os parâmetros obrigatórios e opcionais.
  const AdaptativeTextfield({
    super.key, // Chama o construtor da classe pai (superclasse).
    required this.label, // Parâmetro obrigatório: rótulo do campo.
    // Parâmetro opcional: tipo de teclado (padrão é TextInputType.text).
    this.keyboardType = TextInputType.text,
    required this.controller, // Parâmetro obrigatório: controlador do campo.
    // Parâmetro opcional: indicação de texto obscurecido (padrão é false).
    this.isObscure = false,
    // Parâmetro opcional: ícone a ser exibido no campo.
    this.iconButton,
    // Parâmetro opcional: nextFocus, nem sempre vai precisar focar no próximo.
    this.nextFocus,
    required this.thisFocus,
  });

  // Implementação do método de construção do componente.
  @override
  Widget build(BuildContext context) {
    // Retorna um TextField, um widget de campo de texto padrão do Flutter.
    return TextField(
      // Define o controlador fornecido como o controlador do TextField.
      controller: controller,
      // Define o tipo de teclado fornecido para o TextField.
      keyboardType: keyboardType,
      // Define se o texto deve ser obscurecido com base no parâmetro fornecido.
      obscureText: isObscure,
      // Quando apertar o enter, vai para o próximo campo. Se o nextFocus for vazio faz nada
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      focusNode: thisFocus,
      // Quando apertar o enter, vai para o próximo campo. Se o nextFocus for vazio faz nada
      onSubmitted: nextFocus != null
          ? (_) => FocusScope.of(context).requestFocus(nextFocus)
          : (_) {},
      style: TextStyle(
        // Define a cor do texto com base no tema atual.
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      decoration: InputDecoration(
        // Define o rótulo do campo de texto com base no parâmetro fornecido.
        label: Text(
          label,
        ),
        // Define o ícone a ser exibido à direita do campo com base no parâmetro fornecido.
        suffixIcon: iconButton,
      ),
    );
  }
}
