import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String texto;
  final Function() onPressed;
  const AdaptativeButton({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(238, 218, 231, 1),
            Color.fromRGBO(201, 190, 238, 1),
          ],
        ),
      ),
      height: 120,
      width: 480,
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // Deixar arredondado igual no container
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          texto,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
