import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  bool _isLoading = false;
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confpasswordController = TextEditingController();
  // Variável para controlar a visibilidade da senha
  bool _esconderSenha = true;
  bool _esconderConfirmarSenha = true;
  // Chave que irá identificar o formulário no submit
  final _formKey = GlobalKey<FormState>();

  // Função para alternar a visibilidade da senha
  void _mudarVisibilidadeSenha() {
    setState(() {
      _esconderSenha = !_esconderSenha;
    });
  }

  void _mudarVisibilidadeConfirmarSenha() {
    setState(() {
      _esconderConfirmarSenha = !_esconderConfirmarSenha;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      _codeController.dispose();
      _passwordController.dispose();
      _confpasswordController.dispose();
    }
  }

  void _submitForm() {
    setState(() => _isLoading = true);
    // TODO: Lógica de validação do código / atualização das senhas
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // actionsIconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Esqueceu a sua senha?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Enviaremos um código de validação para o seu email, para que possa criar uma nova senha',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                width: 600,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        decoration: const InputDecoration(hintText: '000000'),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        // Vai adicionar o _formData o valor do campo, se tiver vazio vai botar ''
                        controller: _codeController,
                        validator: (value) {
                          final code = value ?? '';
                          if (code.trim().length < 6) {
                            return 'Informe um código válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: 600,
                        child: TextFormField(
                          controller: _passwordController,
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _esconderSenha
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              ),
                              onPressed: () => _mudarVisibilidadeSenha(),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          obscureText: _esconderSenha,
                          // Vai adicionar o authData o valor do campo, se tiver vazio vai botar ''
                          validator: (value) {
                            final password = value ?? '';
                            List<String> erros = [];
                            // Verificar se a senha é vazia ou tem menos de 5 caracteres
                            if (password.isEmpty || password.length < 5) {
                              erros.add('Preencha ao menos 5 caracteres');
                            }

                            // Verificar se a senha contém pelo menos uma letra maiúscula
                            if (!password.contains(RegExp(r'[A-Z]'))) {
                              erros
                                  .add('Preencha ao menos uma letra maiúscula');
                            }

                            // Verificar se a senha contém pelo menos uma letra minúscula
                            if (!password.contains(RegExp(r'[a-z]'))) {
                              erros
                                  .add('Preencha ao menos uma letra minúscula');
                            }

                            // Verificar se a senha contém pelo menos um número
                            if (!password.contains(RegExp(r'[0-9]'))) {
                              erros.add('Preencha ao menos um número');
                            }

                            // Verificar se a senha contém pelo menos um caractere especial
                            if (!password
                                .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                              erros.add(
                                  'Preencha ao menos um caractere especial');
                            }

                            // Se houver erros, retorna a mensagem concatenada; caso contrário, retorna null
                            return erros.isNotEmpty ? erros.join('\n') : null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 600,
                        child: TextFormField(
                            controller: _confpasswordController,
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: InputDecoration(
                              labelText: 'Confirmar senha',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _esconderConfirmarSenha
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                                onPressed: () =>
                                    _mudarVisibilidadeConfirmarSenha(),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            obscureText: _esconderConfirmarSenha,
                            // Só chama o validador se for tela de Signup
                            validator: (value) {
                              final password = value ?? '';
                              if (password != _passwordController.text) {
                                return 'Senhas informadas não conferem';
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Container(
                      margin: const EdgeInsets.only(top: 25),
                      constraints:
                          const BoxConstraints(minWidth: 240, minHeight: 60),
                      child: ElevatedButton(
                        onPressed: () {
                          _submitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor:
                              const Color.fromRGBO(113, 92, 248, 1),
                        ),
                        child: const Text(
                          'MUDAR SENHA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
