import 'package:flutter/material.dart';
import 'package:iluminaphb/components/request_form.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/service_request.dart';

class RequestFormPage extends StatelessWidget {
  final TipoSolicitacaoEnum tipoSolicitacao;
  final ServiceRequest? solicitacao;
  const RequestFormPage(
      {super.key, required this.tipoSolicitacao, this.solicitacao});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        title: Text(
          tipoSolicitacao == TipoSolicitacaoEnum.INSTALACAO
              ? 'Dados da Solicitação'
              : 'Dados da Reclamação',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RequestForm(
            tipoSolicitacao: tipoSolicitacao,
            req: solicitacao,
          ),
        ),
      ),
    );
  }
}
