import 'package:flutter/material.dart';

class AdaptativeAlertDialog extends StatelessWidget {
  final bool isError;
  final String msg;
  final String corpo;
  const AdaptativeAlertDialog({
    super.key,
    required this.msg,
    required this.corpo,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isError ? Colors.red : Colors.green,
      title: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      content: Text(
        corpo,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'FECHAR',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
