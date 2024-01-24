import 'package:flutter/material.dart';
import 'package:iluminaphb/components/service_order_form.dart';
import 'package:iluminaphb/models/service_order.dart';
import 'package:iluminaphb/models/service_request.dart';

class ServiceOrderFormPage extends StatelessWidget {
  final ServiceRequest solicitacao;
  final ServiceOrder? req;
  const ServiceOrderFormPage({super.key, required this.solicitacao, this.req});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          'Gerar ordem de serviço',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ServiceOrderForm(
            solicitacao: solicitacao,
            req: req,
          ),
        ),
      ),
    );
  }
}
