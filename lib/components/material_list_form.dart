import 'package:flutter/material.dart';
import 'package:iluminaphb/data/dummy_data.dart';
import 'package:iluminaphb/models/service_material.dart';

class MaterialListForm extends StatefulWidget {
  final List<ServiceMaterial> materiaisUsados;
  const MaterialListForm({super.key, required this.materiaisUsados});

  @override
  State<MaterialListForm> createState() => _MaterialListFormState();
}

class _MaterialListFormState extends State<MaterialListForm> {
  final List<ServiceMaterial> _materiais = DUMMY_MATERIAIS;
  // criando uma lista de 'falses' pra poder iniciar o checkbox com
  // o tamanho dos materiais
  List<bool> checkedList =
      List.generate(DUMMY_MATERIAIS.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        height: 200,
        width: 600,
        child: ListView.builder(
          itemCount: _materiais.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              key: ValueKey(_materiais[index].id),
              title: Text(
                _materiais[index].descricao,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: checkedList[index],
              onChanged: (value) {
                setState(() {
                  checkedList[index] = value!;
                  if (checkedList[index]) {
                    widget.materiaisUsados.add(_materiais[index]);
                  } else {
                    widget.materiaisUsados.remove(_materiais[index]);
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
