import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iluminaphb/components/adaptative_alert_dialog.dart';
import 'package:iluminaphb/components/adaptative_button.dart';
import 'package:iluminaphb/components/material_list_form.dart';
import 'package:iluminaphb/components/service_performed_list_form.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:iluminaphb/models/service_material.dart';
import 'package:iluminaphb/models/service_order.dart';
import 'package:iluminaphb/models/service_order_finish.dart';
import 'package:iluminaphb/models/service_order_finish_list.dart';
import 'package:iluminaphb/models/service_order_list.dart';
import 'package:iluminaphb/models/service_performed.dart';
import 'package:iluminaphb/pages/home_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ServiceOrderFinishPage extends StatefulWidget {
  final ServiceOrder ordemServico;
  const ServiceOrderFinishPage({super.key, required this.ordemServico});

  @override
  State<ServiceOrderFinishPage> createState() => _ServiceOrderFinishPageState();
}

class _ServiceOrderFinishPageState extends State<ServiceOrderFinishPage> {
  bool _isLoading = false;
  final List<ServiceMaterial> _materiais = [];
  final List<ServicePerformed> _servicos = [];
  Future<void> _handleSubmit() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }
    final ordemServicoFinalizar = ServiceOrderFinish(
      // Id é desnecessário, vai ser gerado pelo Firebase
      id: Random().nextDouble().toString(),
      ordemServico: widget.ordemServico,
      materiais: _materiais,
      servicos: _servicos,
    );

    try {
      await Provider.of<ServiceOrderFinishList>(context, listen: false)
          .finishServiceOrder(ordemServicoFinalizar)
          .then((value) async {
        final ordem = widget.ordemServico;
        ordem.request.status = 'CONCLUIDO';
        // Atualizar o Status da OS pra CONC
        await Provider.of<ServiceOrderList>(context, listen: false)
            .updateServiceOrder(ordem, ordem.request)
            .then((value) async {
          // Atualizar o Status da requisição pra CONC
          await Provider.of<RequestList>(context, listen: false)
              .atualizarStatus(
            ordem.request,
            ordem.request.status,
          );
        }).then((value) {
          // Dar feedback do user e voltar pra tela inicial
          showDialog(
            context: context,
            builder: (ctx) => AdaptativeAlertDialog(
              msg: 'Ocorreu um erro inesperado',
              corpo: 'Ordem de Serviço ${ordem.numero} foi concluída!',
              isError: false,
            ),
          ).then((value) {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.HOME, arguments: HomePage());
          });
        });
      });
    } catch (error) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (ctx) => AdaptativeAlertDialog(
          msg: 'Ocorreu um erro inesperado',
          corpo: 'Erro: ${error.toString()}',
          isError: true,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          'Finalizar ordem de serviço',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Materiais Utilizados'),
              MaterialListForm(
                materiaisUsados: _materiais,
              ),
              const SizedBox(height: 50),
              const Text('Serviços Realizados'),
              ServicePerformedListForm(
                servicosRealizados: _servicos,
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : AdaptativeButton(
                      texto: 'Finalizar OS',
                      onPressed: () => _handleSubmit(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
