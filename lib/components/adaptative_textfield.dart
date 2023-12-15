// ///
// ///TODO:
// ///Refatorar pra textfield e icones passarem a ser por componente igual no app expenses
// ///   Textfield:
// ///   https://github.com/jonkstro/curso-flutter-expenses/blob/main/lib/components/adaptative_textfield.dart
// ///   Form que chama ele:
// ///   https://github.com/jonkstro/curso-flutter-expenses/blob/main/lib/components/transactions_form.dart


// // Reaproveitaremos o mesmo textfield, por isso estamos criando com função e recebendo params.
//   Widget _createTextField({
//     required String texto,
//     required TextInputType tipoTeclado,
//     required bool esconderSenha,
//     Widget? iconButton,
//   }) {
//     return TextField(
//       style: TextStyle(
//         color: Theme.of(context).textTheme.bodySmall?.color,
//       ),
//       keyboardType: tipoTeclado,
//       obscureText: esconderSenha,
//       decoration: InputDecoration(
//         label: Text(
//           texto,
//         ),
//         suffixIcon: iconButton,
//       ),
//     );
//   }