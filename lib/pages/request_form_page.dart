import 'package:flutter/material.dart';
import 'package:iluminaphb/components/request_form.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/request.dart';

class RequestFormPage extends StatelessWidget {
  final TipoSolicitacaoEnum tipoSolicitacao;
  const RequestFormPage({super.key, required this.tipoSolicitacao});
  @override
  Widget build(BuildContext context) {
    /// Testar passando parametro para edição
    // Request _req = Request(
    //   id: '1',
    //   rua: 'rua',
    //   bairro: 'bairro',
    //   numero: 20,
    //   pontoReferencia: '',
    //   informacaoAdicional: '',
    //   tipoSolicitacao: tipoSolicitacao,
    // );
    return Scaffold(
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
          child: RequestForm(
            tipoSolicitacao: tipoSolicitacao,
            // req: _req,
          ),
        ),
      ),
    );
  }
}
