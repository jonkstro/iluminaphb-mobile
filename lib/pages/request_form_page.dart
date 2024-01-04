import 'package:flutter/material.dart';
import 'package:iluminaphb/components/request_form.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';

class RequestFormPage extends StatelessWidget {
  final TipoSolicitacaoEnum tipoSolicitacao;
  const RequestFormPage({super.key, required this.tipoSolicitacao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Deixar o fundo preto ou branco conforme a cor
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
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
          child: RequestForm(tipoSolicitacao: tipoSolicitacao),
        ),
      ),
    );
  }
}
