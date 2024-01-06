import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';

class Request {
  final String id;
  final String rua;
  final String bairro;
  final int numero;
  final String pontoReferencia;
  final String informacaoAdicional;
  final String tipoSolicitacao;
  final String userId;

  Request({
    required this.id,
    required this.rua,
    required this.bairro,
    required this.numero,
    required this.pontoReferencia,
    required this.informacaoAdicional,
    required this.tipoSolicitacao,
    required this.userId,
  });
}
