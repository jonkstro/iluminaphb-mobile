import 'package:http/http.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:iluminaphb/models/service_request.dart';

class ServiceOrder {
  final String id;
  final String numero;
  final String nomeEncarregado;
  final String nomeEquipe;
  final String numeroAPR;
  final String placaViatura;
  final String kmViatura;
  final String dataOrdemServico;
  final ServiceRequest request;

  ServiceOrder({
    required this.id,
    required this.numero,
    required this.nomeEncarregado,
    required this.nomeEquipe,
    required this.numeroAPR,
    required this.placaViatura,
    required this.kmViatura,
    required this.dataOrdemServico,
    required this.request,
  });
}
