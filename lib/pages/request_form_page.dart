import 'package:flutter/material.dart';
import 'package:iluminaphb/components/request_form.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';

class RequestFormPage extends StatefulWidget {
  final TipoSolicitacaoEnum tipoSolicitacao;
  const RequestFormPage({super.key, required this.tipoSolicitacao});

  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  Color _corFundo = Colors.white;

  void _atualizarCorFundo(Brightness brilho) {
    setState(() {
      // A cor de fundo vai atualizar conforme alterar
      _corFundo = brilho == Brightness.dark ? Colors.black : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Vai pegar o tema atual do celular (light/dark mode)
    Brightness brilhoAtual = MediaQuery.of(context).platformBrightness;

    // Atualiza a cor de fundo com base no tema atual
    _atualizarCorFundo(brilhoAtual);

    return Scaffold(
      /// Deixar o fundo preto ou branco conforme a cor
      backgroundColor: _corFundo,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.tipoSolicitacao == TipoSolicitacaoEnum.INSTALACAO
              ? 'Dados da Solicitação'
              : 'Dados da Reclamação',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RequestForm(tipoSolicitacao: widget.tipoSolicitacao),
        ),
      ),
    );
  }
}
