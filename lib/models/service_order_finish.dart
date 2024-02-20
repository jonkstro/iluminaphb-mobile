import 'package:iluminaphb/models/service_material.dart';
import 'package:iluminaphb/models/service_order.dart';
import 'package:iluminaphb/models/service_performed.dart';

class ServiceOrderFinish {
  final String? id;
  final ServiceOrder? ordemServico;
  final List<ServiceMaterial>? materiais;
  final List<ServicePerformed>? servicos;

  ServiceOrderFinish({
    required this.id,
    required this.ordemServico,
    required this.materiais,
    required this.servicos,
  });
}
