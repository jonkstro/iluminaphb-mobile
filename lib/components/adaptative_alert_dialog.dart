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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      content: Text(
        corpo,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'FECHAR',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
