// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iluminaphb/components/adaptative_alert_dialog.dart';
import 'package:iluminaphb/components/adaptative_button.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/request.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';

class RequestForm extends StatefulWidget {
  final TipoSolicitacaoEnum tipoSolicitacao;
  final Request? req;
  const RequestForm({super.key, required this.tipoSolicitacao, this.req});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _keyForm = GlobalKey<FormState>();
  bool _isLoading = false;

  // Dados do formulário, irá iniciar vazio, esses campos serão enviados no POST
  // Os dados do formulário vão ser jogados nesse mapping
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    if (_formData.isEmpty) {
      // Preencher o tipo de solicitação

      _formData['tipoSolicitacao'] =
          widget.tipoSolicitacao == TipoSolicitacaoEnum.INSTALACAO
              ? 'INSTALACAO'
              : 'MANUTENCAO';
      if (widget.req != null) {
        // Se req não for vazio, quer dizer que tou vindo pra tela de edição
        final request = widget.req as Request;
        _formData['id'] = request.id;
        _formData['rua'] = request.rua;
        _formData['bairro'] = request.bairro;
        _formData['numero'] = request.numero;
        _formData['pontoReferencia'] = request.pontoReferencia;
        _formData['informacaoAdicional'] = request.informacaoAdicional;
        _formData['tipoSolicitacao'] = request.tipoSolicitacao;
      }
    }
  }

  Future<void> _submitForm() async {
    // Validação dos campos do formulario: Se tiver o que validar ele valida,
    //se não tiver nada pra validar (chave for vazia) manda false pois deu algum erro
    final isValid = _keyForm.currentState?.validate() ?? false;
    // Se não for válido (isValid = false) ele vai fazer nada, vai acabar aqui
    if (!isValid) {
      return;
    }

    // Salvar o formulário pra dar pau nas validações
    _keyForm.currentState?.save();

    // Setar os isLoading igual a true, quer dizer que vai tar carregando a página
    setState(() => _isLoading = true);

    // Chamando o método que vai CRIAR/ATUALIZAR a solicitação pelo provider de RequestList
    // Pra não dar erro, vai ter que botar listen = false, pois está fora do build.
    try {
      await Provider.of<RequestList>(context, listen: false)
          .saveRequest(_formData);
      // Voltar pra tela anterior:
      await showDialog(
        context: context,
        builder: (ctx) => const AdaptativeAlertDialog(
          msg: 'Solicitação Registrada!',
          corpo: 'Sua solicitação foi registrada com sucesso!',
          isError: false,
        ),
      );
      // TODO: Navegar pra telinha do eletricista
      Navigator.of(context).pushReplacementNamed(AppRoutes.REQUEST_RECEIVED);
    } catch (error) {
// Se der algum erro, vai abrir um AlertDialog e voltar pra página anterior se apertar OK
      await showDialog(
        context: context,
        builder: (ctx) => AdaptativeAlertDialog(
          msg: 'Ocorreu um erro',
          corpo: error.toString(),
          isError: true,
        ),
      );
    } finally {
      // Independente do que aconteça ele executa o finally

      // Setar os isLoading igual a false, quer dizer que já carregou a página
      setState(() => _isLoading = false);
      // Espera primeiro processar para poder voltar pra tela anterior:
      // Navigator.of(context).pop();
    }
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
                  initialValue: _formData['rua']?.toString(),
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
                  initialValue: _formData['bairro']?.toString(),
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
                  initialValue: _formData['numero']?.toString(),
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
                  initialValue: _formData['pontoReferencia']?.toString(),
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
                  initialValue: _formData['informacaoAdicional']?.toString(),
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
