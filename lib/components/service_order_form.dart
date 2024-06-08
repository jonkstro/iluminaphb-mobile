// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iluminaphb/models/service_order_list.dart';
import 'package:iluminaphb/models/service_request.dart';
import 'package:iluminaphb/pages/service_order_list_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';

import '../models/request_list.dart';
import '../models/service_order.dart';
import 'adaptative_alert_dialog.dart';
import 'adaptative_button.dart';

class ServiceOrderForm extends StatefulWidget {
  final ServiceRequest solicitacao;
  final ServiceOrder? req;
  const ServiceOrderForm({super.key, required this.solicitacao, this.req});

  @override
  State<ServiceOrderForm> createState() => _ServiceOrderFormState();
}

class _ServiceOrderFormState extends State<ServiceOrderForm> {
  final _keyForm = GlobalKey<FormState>();
  bool _isLoading = false;

  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    if (_formData.isEmpty) {
      if (widget.req != null) {
        final ordem = widget.req as ServiceOrder;
        _formData['id'] = ordem.id;
        _formData['numero'] = ordem.numero;
        _formData['nomeEncarregado'] = ordem.nomeEncarregado;
        _formData['nomeEquipe'] = ordem.nomeEquipe;
        _formData['numeroAPR'] = ordem.numeroAPR;
        _formData['placaViatura'] = ordem.placaViatura;
        _formData['kmViatura'] = ordem.kmViatura;
      }
    }
  }

  Future<void> _submitForm() async {
    // Validação dos campos do formulario: Se tiver o que validar ele valida,
    //se não tiver nada pra validar (chave for vazia) manda false pois deu algum erro
    final isValid = _keyForm.currentState?.validate() ?? false;
    // Se não for válido (isValid = false) ele vai fazer nada, vai acabar aqui
    if (!isValid) return;

    // Salvar o formulário pra poder realizar as validações dos campos
    _keyForm.currentState?.save();
    // Setar os isLoading igual a true, quer dizer que vai tar carregando a página
    setState(() => _isLoading = true);
    try {
      await Provider.of<ServiceOrderList>(
        context,
        listen: false,
      ).saveServiceOrder(
        widget.solicitacao,
        _formData,
      );
      await Provider.of<RequestList>(
        context,
        listen: false,
      ).atualizarStatus(
        widget.solicitacao,
        'ANDAMENTO',
      );
      await showDialog(
        context: context,
        builder: (ctx) => const AdaptativeAlertDialog(
          msg: 'Solicitação Registrada!',
          corpo: 'Sua solicitação foi registrada com sucesso!',
          isError: false,
        ),
      );
      // TODO: Navegar para tela de detalhes dessa OS gerada, pra isso, a função de criar/atualizar deverá retornar o objeto da OS.
      // Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.HOME,
        arguments: const ServiceOrderListPage(
          telaSolicitante: 'TelaFuncionario',
        ),
      );
    } catch (error) {
      // Se der algum erro, vai abrir um AlertDialog
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
                initialValue: _formData['nomeEncarregado']?.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  labelText: 'Nome / matricula do eletricista responsável',
                  hintText: 'João Silva / T27435',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (nomeEncarregado) =>
                    _formData['nomeEncarregado'] = nomeEncarregado ?? '',
                validator: (value) {
                  final nomeEncarregado = value ?? '';
                  // Remover espaços em branco no início e no final da string e ver se tem 5 chars
                  if (nomeEncarregado.trim().isEmpty ||
                      nomeEncarregado.trim().length < 5) {
                    return 'Informe um nome/matricula válido';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: 600,
              child: TextFormField(
                initialValue: _formData['nomeEquipe']?.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  labelText: 'Nome do restante da equipe',
                  hintText: 'Maria Silva / José Souza',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (nomeEquipe) =>
                    _formData['nomeEquipe'] = nomeEquipe ?? '',
                validator: (value) {
                  final nomeEquipe = value ?? '';
                  // Remover espaços em branco no início e no final da string e ver se tem 5 chars
                  if (nomeEquipe.trim().isEmpty ||
                      nomeEquipe.trim().length < 5) {
                    return 'Preencha nomes válidos';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: 600,
              child: TextFormField(
                initialValue: _formData['numeroAPR']?.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  labelText: 'Numero da APR',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: false,
                ),
                onSaved: (numeroAPR) =>
                    _formData['numeroAPR'] = numeroAPR ?? '',
                validator: (value) {
                  final numeroAPR = value ?? '';
                  // Remover espaços em branco no início e no final da string e ver se tem 5 chars
                  if (numeroAPR.trim().isEmpty) {
                    return 'Preencha o número da APR';
                  }
                  return null;
                },
              ),
            ),
            // TODO: Criar máscara de validação da placa "remover '-' e deixar UPPER"
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: 600,
              child: TextFormField(
                initialValue: _formData['placaViatura']?.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  labelText: 'Placa da viatura',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (placaViatura) =>
                    _formData['placaViatura'] = placaViatura ?? '',
                validator: (value) {
                  final placaViatura = value ?? '';
                  // Remover espaços em branco no início e no final da string e ver se tem 5 chars
                  if (placaViatura.trim().isEmpty ||
                      placaViatura.trim().length < 5) {
                    return 'Preencha uma placa válida';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: 600,
              child: TextFormField(
                initialValue: _formData['kmViatura']?.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  labelText: 'Quilometragem da viatura',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                onSaved: (kmViatura) =>
                    _formData['kmViatura'] = kmViatura ?? '',
                validator: (value) {
                  final kmViaturaString = value ?? '';
                  final int kmViatura = int.tryParse(kmViaturaString) ?? -1;
                  if (kmViatura < 0) return 'Insira uma quilometragem válida';
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : AdaptativeButton(
                      texto:
                          '${widget.req != null ? 'Atualizar' : 'Gerar'} Ordem de Serviço',
                      onPressed: () => _submitForm(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
