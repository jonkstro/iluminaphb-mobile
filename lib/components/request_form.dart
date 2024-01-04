import 'package:flutter/material.dart';
import 'package:iluminaphb/components/adaptative_button.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';

class RequestForm extends StatefulWidget {
  final TipoSolicitacaoEnum tipoSolicitacao;
  const RequestForm({super.key, required this.tipoSolicitacao});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _keyForm = GlobalKey<FormState>();
  bool _isLoading = false;
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _pontoReferenciaController = TextEditingController();
  final _informacaoAdicionalController = TextEditingController();

  // Dados do formulário, irá iniciar vazio, esses campos serão enviados no POST
  final Map<String, String> _formData = {
    'rua': '',
    'bairro': '',
    'numero': '',
    'ponto_referencia': '',
    'informacao_adicional': '',
    'tipo_solicitacao': '',
  };

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _numeroController.dispose();
    _pontoReferenciaController.dispose();
    _informacaoAdicionalController.dispose();
  }

  void _submitForm() {
    setState(() => _isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: 600,
                child: TextFormField(
                  controller: _ruaController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    labelText: 'Nome da rua',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  // Vai adicionar o _formData o valor do campo, se tiver vazio vai botar ''
                  onSaved: (rua) => _formData['rua'] = rua ?? '',
                  validator: (value) {
                    final rua = value ?? '';
                    // Remover espaços em branco no início e no final da string e ver se tem @
                    if (rua.trim().isEmpty) {
                      return 'Informe um nome de rua válido';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: 600,
                child: TextFormField(
                  controller: _bairroController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    labelText: 'Nome do bairro',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  // Vai adicionar o _formData o valor do campo, se tiver vazio vai botar ''
                  onSaved: (bairro) => _formData['bairro'] = bairro ?? '',
                  validator: (value) {
                    final bairro = value ?? '';
                    // Remover espaços em branco no início e no final da string e ver se tem @
                    if (bairro.trim().isEmpty) {
                      return 'Informe um nome de bairro válido';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: 600,
                child: TextFormField(
                  controller: _numeroController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    labelText: 'Numero da casa',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  // Vai adicionar o _formData o valor do campo, se tiver vazio vai botar ''
                  onSaved: (numero) => _formData['numero'] = numero ?? '',
                  validator: (value) {
                    final numeroString = value ?? '';
                    // Vamos tentar parsear o valor da string, se não conseguir mete um -1 pra dar erro
                    final int numero = int.tryParse(numeroString) ?? -1;

                    if (numero <= 0) {
                      return 'Insira um número válido';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: 600,
                child: TextFormField(
                  controller: _pontoReferenciaController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    labelText: 'Ponto de referência',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  // Vai adicionar o _formData o valor do campo, se tiver vazio vai botar ''
                  onSaved: (pontoReferencia) =>
                      _formData['ponto_referencia'] = pontoReferencia ?? '',
                  validator: (value) {
                    // Não teremos validações para o ponto de referência
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: 600,
                child: TextFormField(
                  controller: _informacaoAdicionalController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    labelText: 'Informações adicionais',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  // Vai adicionar o _formData o valor do campo, se tiver vazio vai botar ''
                  onSaved: (informacaoAdicional) =>
                      _formData['informacao_adicional'] =
                          informacaoAdicional ?? '',
                  validator: (value) {
                    // Não teremos validações para as informações adicionais
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : AdaptativeButton(
                        texto: widget.tipoSolicitacao ==
                                TipoSolicitacaoEnum.INSTALACAO
                            ? 'Registrar Solicitação'
                            : 'Registrar Reclamação',
                        onPressed: () => _submitForm(),
                      ),
              ),
            ],
          )),
    );
  }
}
