import 'package:flutter/material.dart';
import 'package:iluminaphb/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: null,
          child: const AuthForm(),
        ),
      ),
    );
  }
}
