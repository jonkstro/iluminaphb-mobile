class ServiceRequest {
  final String id;
  final String rua;
  final String bairro;
  final int numero;
  final String pontoReferencia;
  final String informacaoAdicional;
  final String tipoSolicitacao;
  String status;
  final String dataSolicitacao;
  final String nomeSolicitante;
  final String userId;

  ServiceRequest({
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
