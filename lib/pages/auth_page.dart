import 'package:flutter/material.dart';
import 'package:iluminaphb/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          decoration: null,
          child: const AuthForm(),
        ),
      ),
    );
  }
}
