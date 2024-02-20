import 'package:flutter/material.dart';
import 'package:iluminaphb/data/dummy_data.dart';
import 'package:iluminaphb/models/service_performed.dart';

class ServicePerformedListForm extends StatefulWidget {
  final List<ServicePerformed> servicosRealizados;
  const ServicePerformedListForm({super.key, required this.servicosRealizados});

  @override
  State<ServicePerformedListForm> createState() =>
      _ServicePerformedListFormState();
}

class _ServicePerformedListFormState extends State<ServicePerformedListForm> {
  final List<ServicePerformed> _servicos = DUMMY_SERVICOS;
  // criando uma lista de 'falses' pra poder iniciar o checkbox com
  // o tamanho dos materiais
  List<bool> checkedList =
      List.generate(DUMMY_SERVICOS.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        height: 200,
        width: 600,
        child: ListView.builder(
          itemCount: _servicos.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              key: ValueKey(_servicos[index].id),
              title: Text(
                _servicos[index].descricao,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: checkedList[index],
              onChanged: (value) {
                setState(() {
                  checkedList[index] = value!;
                  if (checkedList[index]) {
                    widget.servicosRealizados.add(_servicos[index]);
                  } else {
                    widget.servicosRealizados.remove(_servicos[index]);
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}
