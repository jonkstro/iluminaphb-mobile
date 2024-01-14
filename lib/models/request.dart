class Request {
  final String id;
  final String rua;
  final String bairro;
  final int numero;
  final String pontoReferencia;
  final String informacaoAdicional;
  final String tipoSolicitacao;
  final String status;
  final String dataSolicitacao;
  final String nomeSolicitante;
  final String userId;

  Request({
    required this.id,
    required this.rua,
    required this.bairro,
    required this.numero,
    required this.pontoReferencia,
    required this.informacaoAdicional,
    required this.tipoSolicitacao,
    required this.status,
    required this.dataSolicitacao,
    required this.nomeSolicitante,
    required this.userId,
  });
}
