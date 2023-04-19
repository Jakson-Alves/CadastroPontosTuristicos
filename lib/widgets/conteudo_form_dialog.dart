import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/tarefa.dart';

class ConteudoDialogForm extends StatefulWidget {
  final Tarefa? tarefaAtual;

  ConteudoDialogForm({Key? key, this.tarefaAtual}) : super(key: key);

  void init() {}

  @override
  State<StatefulWidget> createState() => ConteudoDialogFormState();
}

class ConteudoDialogFormState extends State<ConteudoDialogForm> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _diferencialController = TextEditingController();
  final _dtAtualController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.tarefaAtual != null) {
      _descricaoController.text = widget.tarefaAtual!.descricao;
      _dtAtualController.text = widget.tarefaAtual!.dtAtualFormatado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(
              labelText: 'Descrição',
            ),
            validator: (String? valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Informe a descrição';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _diferencialController,
            decoration: InputDecoration(
              labelText: 'Diferencial',
            ),
            validator: (String? valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Informe o diferencial';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dtAtualController,
            decoration: InputDecoration(
              labelText: 'Data Atual',
              prefixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _mostrarCalendario,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _dtAtualController.clear(),
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }

  void _mostrarCalendario() async {
    final dataFormatada = _dtAtualController.text;
    DateTime data;
    if (dataFormatada.trim().isNotEmpty) {
      data = _dateFormat.parse(dataFormatada);
    } else {
      data = DateTime.now();
    }
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime.now().subtract(Duration(days: 5 * 365)),
      lastDate: DateTime.now().add(Duration(days: 5 * 365)),
    );
    if (dataSelecionada != null) {
      _dtAtualController.text = _dateFormat.format(dataSelecionada);
    }
  }

  bool dadosValidos() => _formKey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
    id: widget.tarefaAtual?.id,
    descricao: _descricaoController.text,
    diferencial: _diferencialController.text,
    dtAtual: _dtAtualController.text.isEmpty
        ? null
        : _dateFormat.parse(_dtAtualController.text),
  );
}